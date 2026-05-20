import 'package:fresh_base_project/features/users/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../app/config/config.dart';
import '../../../../core/constants/app_url.dart';
import '../../../../core/network/base_remote_data_source.dart';
import '../../../../core/network/rest_service.dart';

/// Data source contract for retrieving users from remote endpoints.
abstract interface class UsersRemoteDataSource {
  /// Fetches users and returns raw data models.
  Future<List<UserModel>> getUsers();
}

/// Remote data source implementation using Dio RestService.
@LazySingleton(as: UsersRemoteDataSource)
class UsersRemoteDataSourceImpl extends BaseRemoteDataSource
    implements UsersRemoteDataSource {
  UsersRemoteDataSourceImpl({required RestService restService})
    : super(restService);

  @override
  Future<List<UserModel>> getUsers() async {
    final String baseUrl = AppConfig.config.baseUrl.trim();
    if (baseUrl.isEmpty) {
      return _mockUsers;
    }

    return getList<UserModel>(
      path: AppUrl.users,
      fromJson: UserModel.fromJson,
      defaultErrorMessage: 'Unable to fetch users from server.',
    );
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
