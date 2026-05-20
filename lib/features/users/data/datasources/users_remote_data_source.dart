import 'package:fresh_base_project/core/config/config.dart';
import 'package:fresh_base_project/core/errors/exceptions.dart';
import 'package:fresh_base_project/core/utils/network/api_error.dart';
import 'package:fresh_base_project/features/users/data/models/user_model.dart';
import 'package:fresh_base_project/features/users/data/datasources/users_api_client.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Data source contract for retrieving users from remote endpoints.
abstract interface class UsersRemoteDataSource {
  /// Fetches users and returns raw data models.
  Future<List<UserModel>> getUsers();
}

/// Remote data source implementation using Dio RestService.
@LazySingleton(as: UsersRemoteDataSource)
class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  UsersRemoteDataSourceImpl({required UsersApiClient apiClient})
    : _apiClient = apiClient;

  final UsersApiClient _apiClient;

  @override
  Future<List<UserModel>> getUsers() async {
    final String baseUrl = AppConfig.config.baseUrl.trim();
    if (baseUrl.isEmpty) {
      return _mockUsers;
    }

    try {
      return await _apiClient.getUsers();
    } on DioException catch (error) {
      throw ServerException(
        message: _mapDioMessage(error),
        code: error.response?.statusCode?.toString(),
      );
    } on ApiError catch (error) {
      throw ServerException(
        message: error.message ?? 'Unable to fetch users from server.',
        code: error.errorCode,
      );
    }
  }

  String _mapDioMessage(DioException error) {
    final dynamic data = error.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }

    return 'Unable to fetch users from server.';
  }
}

final List<UserModel> _mockUsers = <UserModel>[
  const UserModel(
    id: 1,
    name: 'Starter User',
    username: 'starter',
    email: 'starter@example.com',
    phone: '0123456789',
    website: 'example.com',
    address: AddressModel(
      street: 'Main Street',
      suite: 'Suite 100',
      city: 'Template City',
      zipcode: '700000',
      geo: GeoModel(lat: '10.000', lng: '106.000'),
    ),
    company: CompanyModel(
      name: 'Template Inc',
      catchPhrase: 'Build fast, customize faster',
      bs: 'starter-base',
    ),
  ),
];
