// Re-export core types
// export 'package:fresh_base_project/core/types/result.dart';
import 'package:dartz/dartz.dart';

import '../core.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// Standard sync result for pure domain transformations.
typedef Result<T> = Either<Failure, T>;