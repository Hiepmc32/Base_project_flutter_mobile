import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AppFlavor { dev, uat, prod }

/// Global runtime configuration container.
class AppConfig {
  static late BaseConfig config;

  static void setEnvironment({required BaseConfig valueConfig}) {
    config = valueConfig;
  }
}

/// Base runtime config read from dotenv and dart-define.
abstract class BaseConfig {
  AppFlavor get flavor;

  String get appName => _getString('APP_NAME', kAppNameDefine);

  String get baseUrl => _getString('API_BASE_URL', kApiBaseUrlDefine);

  String get authUrl => _getString('AUTH_BASE_URL', kAuthBaseUrlDefine);

  String get websocketUrl => _getString('WEBSOCKET_URL', kWebsocketUrlDefine);

  bool get enableAlice => _getBool('ENABLE_ALICE', kEnableAliceDefine);

  bool get enableHttpLog => _getBool('ENABLE_HTTP_LOG', kEnableHttpLogDefine);

  bool get allowBadCertificates =>
      _getBool('ALLOW_BAD_CERT', kAllowBadCertificatesDefine);

  bool get enableSslPinning =>
      _getBool('ENABLE_SSL_PINNING', kEnableSslPinningDefine);

  bool get enableTokenRefreshQueue =>
      _getBool('ENABLE_TOKEN_REFRESH_QUEUE', kEnableTokenRefreshQueueDefine);

  bool get enableConnectivityGuard =>
      _getBool('ENABLE_CONNECTIVITY_GUARD', kEnableConnectivityGuardDefine);

  List<String> get sslPinnedSha256 =>
      _getCsv('SSL_PINNED_SHA256', kSslPinnedSha256Define);

  List<String> get sslPinnedHosts =>
      _getCsv('SSL_PINNED_HOSTS', kSslPinnedHostsDefine);

  String get authRefreshPath =>
      _getString('AUTH_REFRESH_PATH', kAuthRefreshPathDefine);

  String get authHeaderName =>
      _getString('AUTH_HEADER_NAME', kAuthHeaderNameDefine);

  String get authHeaderPrefix =>
      _getString('AUTH_HEADER_PREFIX', kAuthHeaderPrefixDefine);

  String get authRefreshBodyKey =>
      _getString('AUTH_REFRESH_BODY_KEY', kAuthRefreshBodyKeyDefine);

  String get authAccessTokenKey =>
      _getString('AUTH_ACCESS_TOKEN_KEY', kAuthAccessTokenKeyDefine);

  String get authRefreshTokenKey =>
      _getString('AUTH_REFRESH_TOKEN_KEY', kAuthRefreshTokenKeyDefine);

  int get connectTimeoutSeconds =>
      _getInt('CONNECT_TIMEOUT_SECONDS', kConnectTimeoutSecondsDefine);

  int get receiveTimeoutSeconds =>
      _getInt('RECEIVE_TIMEOUT_SECONDS', kReceiveTimeoutSecondsDefine);
}

const String kAppNameDefine = String.fromEnvironment(
  'APP_NAME',
  defaultValue: 'Fresh Base',
);
const String kApiBaseUrlDefine = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: '',
);
const String kAuthBaseUrlDefine = String.fromEnvironment(
  'AUTH_BASE_URL',
  defaultValue: '',
);
const String kWebsocketUrlDefine = String.fromEnvironment(
  'WEBSOCKET_URL',
  defaultValue: '',
);
const bool kEnableAliceDefine = bool.fromEnvironment(
  'ENABLE_ALICE',
  defaultValue: true,
);
const bool kEnableHttpLogDefine = bool.fromEnvironment(
  'ENABLE_HTTP_LOG',
  defaultValue: true,
);
const bool kAllowBadCertificatesDefine = bool.fromEnvironment(
  'ALLOW_BAD_CERT',
  defaultValue: false,
);
const bool kEnableSslPinningDefine = bool.fromEnvironment(
  'ENABLE_SSL_PINNING',
  defaultValue: true,
);
const bool kEnableTokenRefreshQueueDefine = bool.fromEnvironment(
  'ENABLE_TOKEN_REFRESH_QUEUE',
  defaultValue: true,
);
const bool kEnableConnectivityGuardDefine = bool.fromEnvironment(
  'ENABLE_CONNECTIVITY_GUARD',
  defaultValue: true,
);
const String kSslPinnedSha256Define = String.fromEnvironment(
  'SSL_PINNED_SHA256',
  defaultValue: '',
);
const String kSslPinnedHostsDefine = String.fromEnvironment(
  'SSL_PINNED_HOSTS',
  defaultValue: '',
);
const String kAuthRefreshPathDefine = String.fromEnvironment(
  'AUTH_REFRESH_PATH',
  defaultValue: '/auth/refresh-token',
);
const String kAuthHeaderNameDefine = String.fromEnvironment(
  'AUTH_HEADER_NAME',
  defaultValue: 'Authorization',
);
const String kAuthHeaderPrefixDefine = String.fromEnvironment(
  'AUTH_HEADER_PREFIX',
  defaultValue: 'Bearer',
);
const String kAuthRefreshBodyKeyDefine = String.fromEnvironment(
  'AUTH_REFRESH_BODY_KEY',
  defaultValue: 'refresh_token',
);
const String kAuthAccessTokenKeyDefine = String.fromEnvironment(
  'AUTH_ACCESS_TOKEN_KEY',
  defaultValue: 'access_token',
);
const String kAuthRefreshTokenKeyDefine = String.fromEnvironment(
  'AUTH_REFRESH_TOKEN_KEY',
  defaultValue: 'refresh_token',
);
const int kConnectTimeoutSecondsDefine = int.fromEnvironment(
  'CONNECT_TIMEOUT_SECONDS',
  defaultValue: 30,
);
const int kReceiveTimeoutSecondsDefine = int.fromEnvironment(
  'RECEIVE_TIMEOUT_SECONDS',
  defaultValue: 30,
);

String _getString(String key, String fallback) {
  final String? value = _readDotEnv(key);
  if (value == null || value.trim().isEmpty) {
    return fallback;
  }
  return value.trim();
}

bool _getBool(String key, bool fallback) {
  final String? value = _readDotEnv(key);
  if (value == null || value.trim().isEmpty) {
    return fallback;
  }

  final String normalized = value.trim().toLowerCase();
  return normalized == '1' || normalized == 'true' || normalized == 'yes';
}

int _getInt(String key, int fallback) {
  final String? value = _readDotEnv(key);
  if (value == null || value.trim().isEmpty) {
    return fallback;
  }

  return int.tryParse(value.trim()) ?? fallback;
}

List<String> _getCsv(String key, String fallback) {
  final String? value = _readDotEnv(key);
  final String source =
      (value == null || value.trim().isEmpty) ? fallback : value;
  return source
      .split(',')
      .map((String item) => item.trim())
      .where((String item) => item.isNotEmpty)
      .toList(growable: false);
}

String? _readDotEnv(String key) {
  try {
    return dotenv.maybeGet(key);
  } catch (_) {
    return null;
  }
}
