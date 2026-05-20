import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../app/config/config.dart';
import '../../app/di/locator.dart';
import '../../common/extensions/utils.dart';
import '../../common/utils/logging/app_log.dart';
import 'auth_token_store.dart';
import 'connectivity_service.dart';
import 'interceptor_keys.dart';

class LoggingInterceptor implements InterceptorsWrapper {
  String _getLastPath(String? url) {
    final List<String>? parts = url?.split('/');
    final String? lastPart = parts?.last;
    return lastPart ?? '';
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final String lastPart = _getLastPath(err.requestOptions.path);
    final String keyResponse = err.requestOptions.extra['key'] ?? 'Unknown';

    if (err.response?.data is Map || err.response?.data is List) {
      AppLog.log.info(
        '$lastPart <=== [RESPONSE DATA]:${jsonEncode(err.response?.data)} -- [Key = $keyResponse] -- [STATUS = ERROR]',
      );
    } else {
      AppLog.log.info(
        '$lastPart <=== [RESPONSE DATA]:${err.response?.data} -- [Key = $keyResponse] -- [STATUS = ERROR]',
      );
    }

    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String lastPart = _getLastPath(options.path);

    final String key = const Uuid().v4();
    options.extra['key'] = key;

    AppLog.log.info(
      '$lastPart ===> [URL]: ${options.method} ${options.baseUrl}${options.path} -- [Key = $key] -- [STATUS = START]',
    );

    if (options.data != null) {
      AppLog.log.info(
        '$lastPart ===> [REQUEST DATA]: ${options.data} -- [Key = $key]',
      );
    } else if (options.queryParameters.isNotEmpty &&
        !options.path.toLowerCase().contains('login')) {
      AppLog.log.info(
        '$lastPart ===> [REQUEST queryParameters]: ${options.queryParameters} -- [Key = $key]',
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final String lastPart = _getLastPath(response.requestOptions.path);

    final String key = response.requestOptions.extra['key'] ?? 'Unknown';
    if (response.data is Map || response.data is List) {
      AppLog.log.info(
        '$lastPart <=== [RESPONSE DATA]:${jsonEncode(response.data)} -- [Key = $key] -- [STATUS = DONE]',
      );
    } else {
      AppLog.log.info(
        '$lastPart <=== [RESPONSE DATA]:${response.data} -- [Key = $key] -- [STATUS = DONE]',
      );
    }

    handler.next(response);
  }
}

class SessionInterceptor implements InterceptorsWrapper {
  SessionInterceptor({AuthTokenStore? tokenStore, BaseConfig? config})
    : _tokenStore =
          tokenStore ??
          (isRegistered<AuthTokenStore>()
              ? getIt<AuthTokenStore>()
              : throw StateError('AuthTokenStore is not registered.')),
      _config = config ?? AppConfig.config;

  final AuthTokenStore _tokenStore;
  final BaseConfig _config;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final DeviceInfo deviceInfo = DeviceManager().deviceInfo;

    options.headers.addAll(<String, dynamic>{
      'deviceId': deviceInfo.deviceId ?? '',
      'User-Agent': jsonEncode(
        deviceInfo.deviceInfo?.toJson() ?? <String, dynamic>{},
      ),
      'x-client-request-id': const Uuid().v4(),
      'channel': 'app',
      'clientTime': DateTime.now().formatDDMMYYYHHMMSS,
      'platform': DevicePlatformManager().devicePlatform.value,
      'x-app-flavor': AppConfig.config.flavor.name,
    });

    if (options.extra[kSkipAuthHeader] != true) {
      final String? token = _tokenStore.accessToken;
      if (token != null) {
        options.headers[_config.authHeaderName] = _buildAuthHeader(token);
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.data is String) {
      response.data = jsonDecode(response.data as String);
    }

    handler.next(response);
  }

  String _buildAuthHeader(String token) {
    final String prefix = _config.authHeaderPrefix.trim();
    if (prefix.isEmpty) {
      return token;
    }
    return '$prefix $token';
  }
}

class ConnectivityGuardInterceptor extends Interceptor {
  ConnectivityGuardInterceptor({
    ConnectivityService? connectivityService,
    BaseConfig? config,
  }) : _connectivityService =
           connectivityService ??
           (isRegistered<ConnectivityService>()
               ? getIt<ConnectivityService>()
               : ConnectivityService()),
       _config = config ?? AppConfig.config;

  final ConnectivityService _connectivityService;
  final BaseConfig _config;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_config.enableConnectivityGuard ||
        options.extra[kSkipConnectivityGuard] == true) {
      handler.next(options);
      return;
    }

    bool hasConnection = false;
    try {
      hasConnection = await _connectivityService.hasConnection();
    } catch (_) {
      hasConnection = false;
    }

    if (hasConnection) {
      handler.next(options);
      return;
    }

    handler.reject(
      DioException.connectionError(
        requestOptions: options,
        reason: 'No internet connection.',
      ),
    );
  }
}

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(
    this.dio, {
    AuthTokenStore? tokenStore,
    BaseConfig? config,
  }) : _tokenStore =
           tokenStore ??
           (isRegistered<AuthTokenStore>()
               ? getIt<AuthTokenStore>()
               : throw StateError('AuthTokenStore is not registered.')),
       _config = config ?? AppConfig.config;

  final Dio dio;
  final AuthTokenStore _tokenStore;
  final BaseConfig _config;

  Completer<void>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_config.enableTokenRefreshQueue ||
        options.extra[kSkipTokenRefresh] == true ||
        options.extra[kSkipRefreshQueue] == true ||
        _refreshCompleter == null) {
      handler.next(options);
      return;
    }

    try {
      await _refreshCompleter!.future;
      _attachLatestToken(options);
      handler.next(options);
    } catch (error, stackTrace) {
      handler.reject(_toDioException(error, options, stackTrace));
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldHandle401(err)) {
      handler.next(err);
      return;
    }

    final String? refreshToken = _tokenStore.refreshToken;
    if (refreshToken == null) {
      handler.next(err);
      return;
    }

    try {
      await _refreshOrWait(refreshToken);
    } catch (_) {
      await _tokenStore.clear();
      handler.next(err);
      return;
    }

    try {
      final Response<dynamic> response = await _retryRequest(
        err.requestOptions,
      );
      handler.resolve(response);
    } catch (retryError, retryStackTrace) {
      handler.reject(
        _toDioException(retryError, err.requestOptions, retryStackTrace),
      );
    }
  }

  bool _shouldHandle401(DioException err) {
    final int statusCode = err.response?.statusCode ?? 0;
    if (statusCode != 401) {
      return false;
    }

    final RequestOptions requestOptions = err.requestOptions;
    if (!_config.enableTokenRefreshQueue) {
      return false;
    }

    if (requestOptions.extra[kSkipTokenRefresh] == true ||
        requestOptions.extra[kRetriedAfterRefresh] == true) {
      return false;
    }

    final String refreshPath = _normalizedRefreshPath();
    if (refreshPath.isNotEmpty &&
        requestOptions.uri.path.endsWith(refreshPath)) {
      return false;
    }

    return true;
  }

  Future<void> _refreshOrWait(String refreshToken) async {
    if (_refreshCompleter != null) {
      await _refreshCompleter!.future;
      return;
    }

    final Completer<void> completer = Completer<void>();
    _refreshCompleter = completer;

    try {
      await _refreshAccessToken(refreshToken);
      completer.complete();
    } catch (error, stackTrace) {
      completer.completeError(error, stackTrace);
      rethrow;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<void> _refreshAccessToken(String refreshToken) async {
    final String refreshPath = _config.authRefreshPath.trim();
    if (refreshPath.isEmpty) {
      throw StateError('AUTH_REFRESH_PATH is empty.');
    }
    final String refreshUrl = _resolveRefreshUrl(refreshPath);

    final Response<dynamic> response = await dio.post<dynamic>(
      refreshUrl,
      data: <String, dynamic>{_config.authRefreshBodyKey: refreshToken},
      options: Options(
        extra: <String, dynamic>{
          kSkipAuthHeader: true,
          kSkipTokenRefresh: true,
          kSkipRefreshQueue: true,
        },
      ),
    );

    final ({String? accessToken, String? refreshToken}) pair = _extractTokens(
      response.data,
    );
    final String accessToken = pair.accessToken ?? '';
    if (accessToken.isEmpty) {
      throw StateError('Missing access token in refresh response.');
    }

    await _tokenStore.saveTokens(
      accessToken: accessToken,
      refreshToken: pair.refreshToken,
    );
  }

  String _resolveRefreshUrl(String refreshPath) {
    if (refreshPath.startsWith('http://') ||
        refreshPath.startsWith('https://')) {
      return refreshPath;
    }

    final String authUrl = _config.authUrl.trim();
    if (authUrl.isEmpty) {
      return refreshPath;
    }

    return Uri.parse(authUrl).resolve(refreshPath).toString();
  }

  String _normalizedRefreshPath() {
    final String refreshPath = _config.authRefreshPath.trim();
    if (refreshPath.isEmpty) {
      return '';
    }
    final Uri uri = Uri.parse(_resolveRefreshUrl(refreshPath));
    return uri.path;
  }

  ({String? accessToken, String? refreshToken}) _extractTokens(dynamic data) {
    final Map<String, dynamic> root = _asMap(data);
    final Map<String, dynamic> payload = _asMap(root['data']);

    final String? accessToken =
        _pickToken(root, <String>[
          _config.authAccessTokenKey,
          'accessToken',
          'token',
        ]) ??
        _pickToken(payload, <String>[
          _config.authAccessTokenKey,
          'accessToken',
          'token',
        ]);

    final String? refreshToken =
        _pickToken(root, <String>[
          _config.authRefreshTokenKey,
          'refreshToken',
        ]) ??
        _pickToken(payload, <String>[
          _config.authRefreshTokenKey,
          'refreshToken',
        ]);

    return (accessToken: accessToken, refreshToken: refreshToken);
  }

  String? _pickToken(Map<String, dynamic> source, List<String> keys) {
    for (final String key in keys) {
      final dynamic value = source[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  Map<String, dynamic> _asMap(dynamic source) {
    if (source is Map<String, dynamic>) {
      return source;
    }
    if (source is Map) {
      return source.map(
        (dynamic key, dynamic value) => MapEntry('$key', value),
      );
    }
    return <String, dynamic>{};
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final Map<String, dynamic> headers = Map<String, dynamic>.from(
      requestOptions.headers,
    );
    final Map<String, dynamic> extra = Map<String, dynamic>.from(
      requestOptions.extra,
    );
    extra[kRetriedAfterRefresh] = true;

    final String? accessToken = _tokenStore.accessToken;
    if (accessToken != null && accessToken.isNotEmpty) {
      headers[_config.authHeaderName] = _buildAuthHeader(accessToken);
    }

    final RequestOptions retried = requestOptions.copyWith(
      headers: headers,
      extra: extra,
    );
    return dio.fetch<dynamic>(retried);
  }

  void _attachLatestToken(RequestOptions options) {
    if (options.extra[kSkipAuthHeader] == true) {
      return;
    }

    final String? accessToken = _tokenStore.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      return;
    }

    options.headers[_config.authHeaderName] = _buildAuthHeader(accessToken);
  }

  String _buildAuthHeader(String token) {
    final String prefix = _config.authHeaderPrefix.trim();
    if (prefix.isEmpty) {
      return token;
    }
    return '$prefix $token';
  }

  DioException _toDioException(
    dynamic error,
    RequestOptions requestOptions,
    StackTrace stackTrace,
  ) {
    if (error is DioException) {
      return error;
    }

    return DioException(
      requestOptions: requestOptions,
      error: error,
      stackTrace: stackTrace,
      type: DioExceptionType.unknown,
    );
  }
}
