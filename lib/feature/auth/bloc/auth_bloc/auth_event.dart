import 'package:pasa/feature/auth/models/signup_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_event.freezed.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signIn({
    required String email,
    required String password,
  }) = AuthEventSignIn;
  const factory AuthEvent.signUp({
    required String password,
    required SignupModel signupData,
  }) = AuthEventSignUp;
  const factory AuthEvent.sessionRestored({required Session session}) =
      AuthEventSessionRestored;
  const factory AuthEvent.completeSignup({required Session session}) =
      AuthEventCompleteSignup;
  const factory AuthEvent.resendEmailConfirmation({required String email}) =
      AuthEventResendEmailConfirmation;
  const factory AuthEvent.resendEmailConfirmationSignIn({
    required String email,
  }) = AuthEventResendEmailConfirmationSignIn;
}
