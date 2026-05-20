import 'package:fresh_base_project/core/types/result.dart';
import 'package:fresh_base_project/features/users/domain/entities/user_entity.dart';

/// Contract for user-related domain operations.
abstract interface class UsersRepository {
  /// Returns users from remote/local data sources.
  ResultFuture<List<UserEntity>> getUsers();
}
