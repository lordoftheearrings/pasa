import 'package:pasa/core/exception/base_exception.dart';
import 'package:pasa/core/exception/exception_messages.dart';
import 'package:pasa/core/exception/unguarded_exception.dart';
import 'package:pasa/feature/auth/exceptions/supabase_auth_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthExceptionMapper {
  static BaseException fromSupabaseError(AuthException e) {
    final code = e.code ?? 'unknown';

    switch (code) {
      case 'invalid_credentials':
      case 'bad_jwt':
      case 'invalid_grant':
        return SupabaseAuthException(
          code: code,
          message: 'Invalid email or password.',
          statusCode: e.statusCode,
          original: e,
        );

      case 'email_exists':
      case 'user_already_exists':
        return SupabaseAuthException(
          code: code,
          message: 'This email already exists.',
          statusCode: e.statusCode,
          original: e,
        );
      case 'validation_failed':
        return SupabaseAuthException(
          code: code,
          message: 'Your input is not valid.',
          statusCode: e.statusCode,
          original: e,
        );

      case 'unexpected_failure':
        return SupabaseAuthException(
          code: code,
          message: 'Server error. Please try again later.',
          statusCode: e.statusCode,
          original: e,
        );

      case 'email_not_confirmed':
      case 'phone_not_confirmed':
        return SupabaseAuthException(
          code: code,
          message: 'Please verify your account before signing in.',
          statusCode: e.statusCode,
          original: e,
        );

      case 'over_request_rate_limit':
      case 'over_email_send_rate_limit':
      case 'over_sms_send_rate_limit':
        return SupabaseAuthException(
          code: code,
          message: 'Too many requests. Try again later.',
          statusCode: e.statusCode,
          original: e,
        );

      case 'signup_disabled':
      case 'email_provider_disabled':
        return SupabaseAuthException(
          code: code,
          message: 'Signups are currently disabled.',
          statusCode: e.statusCode,
          original: e,
        );
    }

    if (code.contains('invalid')) {
      return SupabaseAuthException(
        code: code,
        message: 'Invalid request. Please check your input.',
        statusCode: e.statusCode,
        original: e,
      );
    }

    if (code.contains('exists')) {
      return SupabaseAuthException(
        code: code,
        message: 'This account already exists.',
        statusCode: e.statusCode,
        original: e,
      );
    }

    if (code.contains('not_found')) {
      return SupabaseAuthException(
        code: code,
        message: 'The requested data was not found.',
        statusCode: e.statusCode,
        original: e,
      );
    }

    return UnguardedException(
      message: ExceptionMessages.userFriendlyMessage,
      original: e,
    );
  }
}
