import 'package:pasa/core/exception/exception_messages.dart';
import 'package:pasa/feature/auth/exceptions/supabase_auth_exception.dart';
import 'package:pasa/feature/auth/models/signup_model.dart';
import 'package:pasa/feature/auth/models/user_model.dart';
import 'package:pasa/feature/auth/repositories/base_auth_repository.dart';
import 'package:pasa/feature/auth/services/base_auth_services.dart';

class AuthRepository extends BaseAuthRepository {
  final BaseAuthServices authService;

  AuthRepository({required this.authService});

  @override
  Future<UserData?> signIn(String email, String password) async {
    final response = await authService.signIn(email, password);
    final user = response.user;
    final session = response.session;
    if (user == null || session == null) {
      throw SupabaseAuthException(
        message: ExceptionMessages.userFriendlyMessage,
      );
    }
    return UserData.fromJson(user.toJson());
  }

  @override
  Future<UserData?> signUp(String password, SignupModel signupData) async {
    final response = await authService.signUp(password, signupData);
    final user = response.user;
    if (user == null) {
      throw SupabaseAuthException(
        message: ExceptionMessages.userFriendlyMessage,
      );
    }
    final userData = user.toJson();

    return UserData.fromJson(userData);
  }

  @override
  Future<void> completeSignup(UserData user, SignupModel signupData) async {
    await authService.completeSignup(user, signupData);
  }

  @override
  Future<void> resendEmailConfirmationLink(String email) async {
    await authService.resendEmailConfirmationLink(email);
  }

  @override
  Future<void> resendEmailConfirmationLinkfromSignIn(String email) async {
    await authService.resendEmailConfirmationLinkfromSignIn(email);
  }

  @override
  Future<void> resetPasswordEmail(String email) async {
    await authService.resetPasswordEmail(email);
  }

  @override
  Future<void> updatePassword(String password) async {
    await authService.updatePassword(password);
  }

  @override
  Future<void> signOut() async {
    await authService.signOut();
  }
}
