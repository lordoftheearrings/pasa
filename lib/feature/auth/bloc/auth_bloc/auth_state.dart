import 'package:pasa/feature/auth/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.verificationNeeded(UserData user) =
      AuthVerificationNeeded;
  const factory AuthState.verificationNeededfromSignIn(String email) =
      AuthVerificationNeededFromSignIn;
  const factory AuthState.authenticated(UserData user) = AuthAuthenticated;
  const factory AuthState.otpResent({@Default(0) int resendId}) = AuthOtpResent;
  const factory AuthState.error(String message) = AuthError;
}
