import 'package:pasa/feature/auth/models/signup_model.dart';
import 'package:pasa/feature/auth/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BaseAuthServices {
  Future<AuthResponse> signIn(String email, String password);
  Future<AuthResponse> signUp(String password, SignupModel signupData);
  Future<void> completeSignup(UserData user, SignupModel signupData);
  Future<void> resendEmailConfirmationLink(String email);
  Future<void> resendEmailConfirmationLinkfromSignIn(String email);
  Future<void> resetPasswordEmail(String email);
  Future<void> updatePassword(String password);
  Future<void> signOut();
}
