import 'package:dartz/dartz.dart';
import 'package:fresh_base_project/core/errors/exceptions.dart';
import 'package:fresh_base_project/core/errors/failure.dart';
import 'package:fresh_base_project/core/types/result.dart';
import 'package:fresh_base_project/features/users/data/datasources/users_remote_data_source.dart';
import 'package:fresh_base_project/features/users/domain/entities/user_entity.dart';
import 'package:fresh_base_project/features/users/domain/repositories/users_repository.dart';
import 'package:injectable/injectable.dart';

/// Repository implementation that maps data models to domain entities.
@LazySingleton(as: UsersRepository)
class UsersRepositoryImpl implements UsersRepository {
  UsersRepositoryImpl({required UsersRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final UsersRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<UserEntity>> getUsers() async {
    try {
      final users = await _remoteDataSource.getUsers();
      final entities = users
          .map((model) => model.toEntity())
          .toList(growable: false);
      return Right<Failure, List<UserEntity>>(entities);
    } on ServerException catch (error) {
      return Left<Failure, List<UserEntity>>(
        ServerFailure(message: error.message, code: error.code),
      );
    } catch (error) {
      return Left<Failure, List<UserEntity>>(
        UnknownFailure(message: error.toString()),
      );
    }
  }
}
