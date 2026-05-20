import 'package:dio/dio.dart';
import 'package:fresh_base_project/core/errors/exceptions.dart';

import 'api_error.dart';
import 'api_response.dart';
import 'rest_service.dart';

/// Shared helpers for simple remote data sources backed by [RestService].
abstract class BaseRemoteDataSource {
  BaseRemoteDataSource(this.restService);

  final RestService restService;

  Future<List<T>> getList<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic>? queryParameters,
    String defaultErrorMessage = 'Unable to load data from server.',
  }) {
    return execute(() async {
      final dynamic response = await restService.get(
        path,
        queryParameters: queryParameters,
      );
      final dynamic data = unwrapData(response);
      if (data is! List) {
        throw ServerException(message: defaultErrorMessage);
      }

      return data
          .map((dynamic item) => fromJson(_asMap(item)))
          .toList(growable: false);
    }, defaultErrorMessage: defaultErrorMessage);
  }

  Future<T> getItem<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic>? queryParameters,
    String defaultErrorMessage = 'Unable to load data from server.',
  }) {
    return execute(() async {
      final dynamic response = await restService.get(
        path,
        queryParameters: queryParameters,
      );
      final dynamic data = unwrapData(response);
      if (data is! Map) {
        throw ServerException(message: defaultErrorMessage);
      }

      return fromJson(_asMap(data));
    }, defaultErrorMessage: defaultErrorMessage);
  }

  Future<T> execute<T>(
    Future<T> Function() action, {
    String defaultErrorMessage = 'Unable to load data from server.',
  }) async {
    try {
      return await action();
    } on ServerException {
      rethrow;
    } on DioException catch (error) {
      throw ServerException(
        message: _mapDioMessage(error, defaultErrorMessage),
        code: error.response?.statusCode?.toString(),
      );
    } on ApiError catch (error) {
      throw ServerException(
        message: error.message ?? defaultErrorMessage,
        code: error.errorCode,
      );
    }
  }

  dynamic unwrapData(dynamic response) {
    if (response is ApiResponse) {
      return response.data;
    }
    return response;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((dynamic key, dynamic item) => MapEntry('$key', item));
    }
    throw const ServerException(message: 'Invalid response format.');
  }

  String _mapDioMessage(DioException error, String fallback) {
    final dynamic data = error.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return fallback;
  }
}
