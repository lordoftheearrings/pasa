import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pasa/feature/auth/models/signup_model.dart';

part 'signup_state.freezed.dart';

@freezed
abstract class SignupState with _$SignupState {
  const factory SignupState.data({
    required SignupModel signupData,
    String? password,
    String? error,
  }) = SignupData;

  factory SignupState.initial() =>
      SignupState.data(signupData: const SignupModel.data());
}
