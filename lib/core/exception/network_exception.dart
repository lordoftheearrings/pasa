import 'package:pasa/core/exception/guarded_exception.dart';

class NetworkException extends GuardedException {
  NetworkException({required super.message, super.original});
}
