import 'dart:io';

import 'package:pasa/core/exception/exception_messages.dart';
import 'package:pasa/core/exception/network_exception.dart';
import 'package:pasa/core/urls/app_link_urls.dart';
import 'package:pasa/feature/auth/exceptions/auth_exception_mapper.dart';
import 'package:pasa/feature/auth/models/signup_model.dart';
import 'package:pasa/feature/auth/models/user_model.dart';
import 'package:pasa/feature/auth/services/base_auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices extends BaseAuthServices {
  final SupabaseClient _supabase;

  AuthServices(this._supabase);

  @override
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthApiException catch (e) {
      throw AuthExceptionMapper.fromSupabaseError(e);
    } on SocketException catch (e) {
      throw NetworkException(
        message: ExceptionMessages.noNetworkMessage,
        original: e,
      );
    }
  }

  @override
  Future<AuthResponse> signUp(String password, SignupModel signupData) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        password: password,
        email: signupData.email,
        emailRedirectTo: 'pasa://auth/${AppLinkUrls.verifyUser}',
      );
      return response;
    } on AuthApiException catch (e) {
      throw AuthExceptionMapper.fromSupabaseError(e);
    } on SocketException catch (e) {
      throw NetworkException(
        message: ExceptionMessages.noNetworkMessage,
        original: e,
      );
    }
  }

  @override
  Future<void> completeSignup(UserData user, SignupModel signupData) async {
    await _supabase.from('user_profile').insert({
      'user_id': user.id,
      'name': signupData.name ?? user.name,
      'email': (signupData.email?.trim().isNotEmpty ?? false)
          ? signupData.email
          : user.email,
      'phone': signupData.phone ?? user.phone,
      'address': signupData.address,
      'blood_group': signupData.bloodGroup,
      'emergency_note': signupData.emergencyNote,
      'gender': signupData.gender,
      'dob': signupData.dob?.toIso8601String(),
    });
    await _supabase.auth.refreshSession();
  }

  @override
  Future<void> resendEmailConfirmationLink(String email) async {
    await _supabase.auth.resend(
      type: OtpType.signup,
      email: email,
      emailRedirectTo: 'pasa://auth/${AppLinkUrls.verifyUser}',
    );
  }

  @override
  Future<void> resendEmailConfirmationLinkfromSignIn(String email) async {
    await _supabase.auth.resend(
      type: OtpType.signup,
      email: email,
      emailRedirectTo: 'pasa://auth/${AppLinkUrls.verifyUserbutHasNoProfile}',
    );
  }
}
