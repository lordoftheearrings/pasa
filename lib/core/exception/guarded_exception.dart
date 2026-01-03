import 'package:pasa/core/exception/base_exception.dart';

class GuardedException extends BaseException {
  const GuardedException({
    required super.message,
    super.code,
    super.statusCode,
    super.original,
  });
}
