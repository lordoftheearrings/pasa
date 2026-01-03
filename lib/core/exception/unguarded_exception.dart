import 'package:pasa/core/exception/base_exception.dart';

class UnguardedException extends BaseException {
  const UnguardedException({
    required super.message,
    super.code,
    super.statusCode,
    super.original,
  });
}
