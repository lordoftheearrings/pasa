abstract class BaseException implements Exception {
  final String message;
  final String? code;
  final String? statusCode;
  final dynamic original;

  const BaseException({
    required this.message,
    this.code,
    this.statusCode,
    this.original,
  });
}
