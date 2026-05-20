import 'package:dartz/dartz.dart';
import 'package:fresh_base_project/core/errors/failure.dart';

/// Standard async result for domain/data boundaries.
typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// Standard sync result for pure domain transformations.
typedef Result<T> = Either<Failure, T>;
