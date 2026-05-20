import 'package:dio/dio.dart';
import 'package:fresh_base_project/core/config/config.dart';
import 'package:fresh_base_project/core/utils/network/rest_client.dart';

class RestService extends BaseRestClient {
  factory RestService() {
    final String currentBaseUrl = AppConfig.config.baseUrl;
    if (_singleton == null || _singleton!.baseUrl != currentBaseUrl) {
      _singleton = RestService._internal(currentBaseUrl, interceptors: null);
    }
    return _singleton!;
  }

  RestService._internal(String baseUrl, {List<Interceptor>? interceptors})
    : super(baseUrl, interceptors);

  static RestService? _singleton;
}
