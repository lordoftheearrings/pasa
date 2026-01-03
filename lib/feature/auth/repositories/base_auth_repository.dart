import 'package:pasa/feature/auth/models/signup_model.dart';
import 'package:pasa/feature/auth/models/user_model.dart';

abstract class BaseAuthRepository {
  Future<UserData?> signIn(String email, String password);
  Future<UserData?> signUp(String password, SignupModel signupData);
  Future<void> completeSignup(UserData user, SignupModel signupData);
  Future<void> resendEmailConfirmationLink(String email);
  Future<void> resendEmailConfirmationLinkfromSignIn(String email);
}
