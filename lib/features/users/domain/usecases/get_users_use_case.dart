import 'package:fresh_base_project/core/types/result.dart';
import 'package:fresh_base_project/features/users/domain/entities/user_entity.dart';
import 'package:fresh_base_project/features/users/domain/repositories/users_repository.dart';
import 'package:injectable/injectable.dart';

/// Use case to fetch user list for presentation.
@injectable
class GetUsersUseCase {
  const GetUsersUseCase(this._repository);

  final UsersRepository _repository;

  /// Executes the users fetching flow.
  ResultFuture<List<UserEntity>> call() => _repository.getUsers();
}
