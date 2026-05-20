import 'package:dio/dio.dart';
import 'package:fresh_base_project/core/utils/ui/app_url.dart';
import 'package:fresh_base_project/features/users/data/models/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'users_api_client.g.dart';

/// Typed API client for users endpoints.
@RestApi()
abstract class UsersApiClient {
  factory UsersApiClient(Dio dio, {String? baseUrl}) = _UsersApiClient;

  /// Returns user list from remote endpoint.
  @GET(AppUrl.users)
  Future<List<UserModel>> getUsers();
}
