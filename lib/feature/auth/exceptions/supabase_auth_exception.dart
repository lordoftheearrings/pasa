import 'package:pasa/core/exception/guarded_exception.dart';

class SupabaseAuthException extends GuardedException {
  SupabaseAuthException({
    required super.message,
    super.code,
    super.statusCode,
    super.original,
  });
}
