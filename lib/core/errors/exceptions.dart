/// Base exception for data layer operations.
class AppException implements Exception {
  const AppException({required this.message, this.code});

  final String message;
  final String? code;

  @override
  String toString() =>
      'AppException(message: $message, code: ${code ?? 'N/A'})';
}

/// Exception for API/network related operations.
class ServerException extends AppException {
  const ServerException({required super.message, super.code});
}

/// Exception for cache/storage related operations.
class CacheException extends AppException {
  const CacheException({required super.message, super.code});
}
