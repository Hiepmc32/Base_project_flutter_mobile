import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage adapter for access/refresh token in local preferences.
class AuthTokenStore {
  AuthTokenStore({required SharedPreferences preferences})
    : _preferences = preferences;

  static const String accessTokenStorageKey = 'auth_access_token';
  static const String refreshTokenStorageKey = 'auth_refresh_token';

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  final SharedPreferences _preferences;

  String? _accessTokenCache;
  String? _refreshTokenCache;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    _accessTokenCache = _normalize(
      await _readFromSecureOrPrefs(accessTokenStorageKey),
    );
    _refreshTokenCache = _normalize(
      await _readFromSecureOrPrefs(refreshTokenStorageKey),
    );

    _initialized = true;
  }

  String? get accessToken {
    return _accessTokenCache ??
        _normalize(_preferences.getString(accessTokenStorageKey));
  }

  String? get refreshToken {
    return _refreshTokenCache ??
        _normalize(_preferences.getString(refreshTokenStorageKey));
  }

  Future<void> saveAccessToken(String token) async {
    final String normalized = token.trim();
    _accessTokenCache = normalized;
    await _preferences.setString(accessTokenStorageKey, normalized);
    await _writeSecure(accessTokenStorageKey, normalized);
  }

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    if (refreshToken != null && refreshToken.trim().isNotEmpty) {
      final String normalized = refreshToken.trim();
      _refreshTokenCache = normalized;
      await _preferences.setString(refreshTokenStorageKey, normalized);
      await _writeSecure(refreshTokenStorageKey, normalized);
    }
  }

  Future<void> clear() async {
    _accessTokenCache = null;
    _refreshTokenCache = null;
    await _preferences.remove(accessTokenStorageKey);
    await _preferences.remove(refreshTokenStorageKey);
    await _deleteSecure(accessTokenStorageKey);
    await _deleteSecure(refreshTokenStorageKey);
  }

  Future<String?> _readFromSecureOrPrefs(String key) async {
    final String? secure = _normalize(await _readSecure(key));
    if (secure != null) {
      await _preferences.setString(key, secure);
      return secure;
    }
    return _normalize(_preferences.getString(key));
  }

  Future<String?> _readSecure(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeSecure(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (_) {}
  }

  Future<void> _deleteSecure(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (_) {}
  }

  String? _normalize(String? value) {
    if (value == null) {
      return null;
    }
    final String result = value.trim();
    return result.isEmpty ? null : result;
  }
}
