import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio/io.dart';
import 'package:fresh_base_project/core/config/config.dart';
import 'package:fresh_base_project/core/utils/logging/app_log.dart';
import 'package:fresh_base_project/core/utils/logging/alice.dart';
import 'package:fresh_base_project/core/utils/network/api_error.dart';
import 'package:fresh_base_project/core/utils/network/api_response.dart';
import 'package:fresh_base_project/core/utils/network/auth_token_store.dart';
import 'package:fresh_base_project/core/utils/network/interceptors.dart';
import 'package:fresh_base_project/core/utils/network/ssl_pinning.dart';
import 'package:fresh_base_project/locator.dart';

class BaseRestClient {
  BaseRestClient(this.baseUrl, List<Interceptor>? interceptors) {
    final BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: AppConfig.config.connectTimeoutSeconds),
      receiveTimeout: Duration(seconds: AppConfig.config.receiveTimeoutSeconds),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    _dio = Dio(options);
    _configureSslPinning();

    final CookieJar cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(cookieJar));

    _dio.interceptors.add(ConnectivityGuardInterceptor());
    _dio.interceptors.add(RefreshTokenInterceptor(_dio));
    _dio.interceptors.add(SessionInterceptor());

    if (AppConfig.config.enableHttpLog) {
      _dio.interceptors.add(LoggingInterceptor());
    }

    if (AppConfig.config.enableAlice) {
      _dio.interceptors.add(AliceUtils().aliceDioAdapter);
    }

    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  final String baseUrl;
  late final Dio _dio;

  /// Exposes configured Dio instance for typed API clients.
  Dio get dio => _dio;

  void _configureSslPinning() {
    if (!AppConfig.config.enableSslPinning) {
      return;
    }

    final SslPinningValidator validator = SslPinningValidator(
      pinnedValues: AppConfig.config.sslPinnedSha256,
      pinnedHosts: _resolvePinnedHosts(),
    );
    if (!validator.hasPins) {
      AppLog.log.warning(
        'SSL pinning is enabled but SSL_PINNED_SHA256 is empty. '
        'Pinning is skipped.',
      );
      return;
    }

    final HttpClientAdapter adapter = _dio.httpClientAdapter;
    if (adapter is! IOHttpClientAdapter) {
      AppLog.log.warning(
        'SSL pinning is enabled but IO adapter is unavailable.',
      );
      return;
    }

    adapter.validateCertificate = (
      X509Certificate? certificate,
      String host,
      int port,
    ) {
      final bool isValid = validator.validate(certificate, host, port);
      if (!isValid) {
        AppLog.log.warning(
          'Blocked request due to SSL pin mismatch. host=$host port=$port',
        );
      }
      return isValid;
    };
  }

  List<String> _resolvePinnedHosts() {
    if (AppConfig.config.sslPinnedHosts.isNotEmpty) {
      return AppConfig.config.sslPinnedHosts;
    }

    final Set<String> resolvedHosts = <String>{};
    for (final String endpoint in <String>[baseUrl, AppConfig.config.authUrl]) {
      final Uri? uri = Uri.tryParse(endpoint);
      final String host = uri?.host ?? '';
      if (host.isNotEmpty) {
        resolvedHosts.add(host);
      }
    }

    return resolvedHosts.toList(growable: false);
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> getFullResponse(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response<dynamic> response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  ApiError _mapError(dynamic e) {
    if (e is ApiError) {
      return e;
    }

    if (e is DioException) {
      final String code = e.response?.statusCode?.toString() ?? '';

      switch (e.type) {
        case DioExceptionType.sendTimeout:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiError(message: '$errorString ${_getCode(code)}');
        case DioExceptionType.badResponse:
          if (code == '500' ||
              code == '501' ||
              code == '502' ||
              code == '503') {
            return ApiError(
              errorCode: code,
              message: '$errorString ${_getCode(code)}',
            );
          }

          if (code == '400' &&
              e.response?.data != null &&
              e.response?.data is Map<String, dynamic>) {
            final ApiResponse apiResponse = ApiResponse.fromJson(
              e.response!.data as Map<String, dynamic>,
            );
            return ApiError(
              errorCode: apiResponse.errorCode,
              message: apiResponse.message,
              extraData: apiResponse.data,
              params: apiResponse.params,
            );
          }

          String? msg = 'ERROR$code';
          List<String> params = <String>[];
          if (e.response?.data != null && e.response?.data is Map) {
            try {
              final dynamic errorData = e.response!.data;
              final String translatedCode =
                  (errorData['code']?.toString() ?? code).replaceAll('-', '_');
              msg = 'ERROR$translatedCode';

              if (msg.startsWith('ERROR') || msg.isEmpty) {
                msg = '$errorString ${_getCode(code)}';
              }

              final dynamic rawParams = e.response?.data['params'];
              if (rawParams is List) {
                params = rawParams.map((dynamic item) => '$item').toList();
              }
            } catch (_) {
              msg = '$errorString ${_getCode(code)}';
            }
          }

          return ApiError(
            errorCode: code,
            message: msg,
            extraData: e.response?.data,
            params: params,
          );
        case DioExceptionType.cancel:
        case DioExceptionType.unknown:
        default:
          return ApiError(
            errorCode: '${e.error}',
            message: '$errorString ${e.error}',
            extraData: e.response?.data,
          );
      }
    }

    return ApiError(message: '$errorString ${e.toString()}');
  }

  dynamic _mapResponse(dynamic response) {
    if (response is String) {
      final dynamic parsed = jsonDecode(response);
      if (parsed is Map<String, dynamic>) {
        return _mapResponse(parsed);
      }
      return ApiResponse(statusCode: 0, data: parsed);
    }

    if (response is List) {
      return ApiResponse(statusCode: 0, data: response);
    }

    if (response is Map<String, dynamic>) {
      _saveTokensIfPresent(response);

      if (_containsTokenPayload(response)) {
        return response;
      }

      final bool isWrappedResponse =
          response.containsKey('statusCode') ||
          response.containsKey('status') ||
          response.containsKey('errorCode') ||
          response.containsKey('message');

      final ApiResponse apiResponse =
          isWrappedResponse
              ? ApiResponse.fromJson(response)
              : ApiResponse(statusCode: 0, data: response);

      if (apiResponse.statusCode == 1) {
        throw ApiError.fromResponse(apiResponse);
      }

      return apiResponse;
    }

    throw ApiError(extraData: response);
  }

  String _getCode(String code) =>
      (code.isNotEmpty && !code.contains('null')) ? '[$code]' : '';

  String get errorString =>
      'There is an error connecting to the server, please try again.';

  void _saveTokensIfPresent(Map<String, dynamic> response) {
    final String? accessToken = _pickToken(response, <String>[
      AppConfig.config.authAccessTokenKey,
      'accessToken',
      'token',
    ]);
    if (accessToken == null || accessToken.isEmpty) {
      return;
    }

    final String? refreshToken = _pickToken(response, <String>[
      AppConfig.config.authRefreshTokenKey,
      'refreshToken',
    ]);
    if (!isRegistered<AuthTokenStore>()) {
      return;
    }
    unawaited(
      getIt<AuthTokenStore>().saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    );
  }

  bool _containsTokenPayload(Map<String, dynamic> response) {
    return _pickToken(response, <String>[
          AppConfig.config.authAccessTokenKey,
          'access_token',
          'accessToken',
          'token',
        ]) !=
        null;
  }

  String? _pickToken(Map<String, dynamic> source, List<String> keys) {
    final Map<String, dynamic> data = _toMap(source['data']);

    for (final String key in keys) {
      final dynamic rootValue = source[key];
      if (rootValue is String && rootValue.trim().isNotEmpty) {
        return rootValue.trim();
      }

      final dynamic dataValue = data[key];
      if (dataValue is String && dataValue.trim().isNotEmpty) {
        return dataValue.trim();
      }
    }

    return null;
  }

  Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((dynamic key, dynamic value) => MapEntry('$key', value));
    }
    return <String, dynamic>{};
  }
}
