import 'package:equatable/equatable.dart';

/// Base failure type for predictable error handling across layers.
abstract class Failure extends Equatable {
  const Failure({required this.message, this.code});

  final String message;
  final String? code;

  @override
  List<Object?> get props => <Object?>[message, code];
}

/// Failure from remote API or backend responses.
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Failure from local cache/storage operations.
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

/// Fallback failure for unclassified errors.
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.code});
}
