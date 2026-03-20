import 'dart:async';

import 'package:pasa/core/exception/exception_messages.dart';
import 'package:pasa/core/exception/network_exception.dart';
import 'package:pasa/core/services/user_session_service.dart';
import 'package:pasa/feature/auth/exceptions/supabase_auth_exception.dart';
import 'package:pasa/feature/auth/models/user_model.dart';
import 'package:pasa/feature/auth/repositories/base_auth_repository.dart';
import 'package:pasa/feature/auth/services/signup_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final BaseAuthRepository repository;
  final UserSessionService sessionService;
  final SignupService signupService;

  late final StreamSubscription _authSub;

  AuthBloc(this.repository, this.sessionService, this.signupService)
    : super(const AuthState.initial()) {
    on<AuthEventSignIn>(_onSignIn);
    on<AuthEventSignUp>(_onSignUp);
    on<AuthEventCompleteSignup>(_onSignupComplete);
    on<AuthEventResendEmailConfirmation>(_onResendEmailConfirmation);
    on<AuthEventResendEmailConfirmationSignIn>(
      _onResendEmailConfirmationSignIn,
    );

    _authSub = sessionService.sessionStream.listen((session) {
      if (session != null) {
        final pendingData = signupService.getPendingSignupData();
        if (pendingData != null && !signupService.wasSignupJustCompleted()) {
          add(AuthEvent.completeSignup(session: session));
        }
      }
    });
  }
  @override
  Future<void> close() {
    _authSub.cancel();
    return super.close();
  }

  Future<void> _onSignIn(AuthEventSignIn event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    try {
      final user = await repository.signIn(event.email, event.password);
      if (user == null) {
        emit(const AuthState.error("Invalid login response"));
        return;
      }
      emit(AuthState.authenticated(user));
    } on SupabaseAuthException catch (e) {
      if (e.code == 'email_not_confirmed') {
        await repository.resendEmailConfirmationLinkfromSignIn(event.email);
        emit(AuthState.verificationNeededfromSignIn(event.email));
      } else {
        emit(AuthState.error(e.message));
      }
    } on NetworkException catch (e) {
      emit(AuthState.error(e.message));
    } catch (e) {
      emit(AuthState.error(ExceptionMessages.userFriendlyMessage));
    }
  }

  Future<void> _onSignUp(AuthEventSignUp event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    try {
      final user = await repository.signUp(event.password, event.signupData);
      if (user == null) {
        emit(const AuthState.error("Invalid signup response"));
        return;
      }

      // If session exists immediately (e.g. auto-confirm is on)
      // the listener in constructor will trigger completeSignup. 
      
      emit(AuthState.verificationNeeded(user));
    } on SupabaseAuthException catch (e) {
      emit(AuthState.error(e.message));
    } on NetworkException catch (e) {
      emit(AuthState.error(e.message));
    } catch (e) {
      emit(AuthState.error(ExceptionMessages.userFriendlyMessage));
    }
  }

  Future<void> _onSignupComplete(
    AuthEventCompleteSignup event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final user = event.session.user;
    final userData = UserData.fromJson(user.toJson());
    final signupData = signupService.getPendingSignupData();
    if (user.emailConfirmedAt == null) {
      emit(const AuthState.error("Email not verified"));
      return;
    }
    if (signupData == null) {
      emit(const AuthState.error("No signup data found"));
      return;
    }
    try {
      await repository.completeSignup(userData, signupData);
      await signupService.markSignupCompleted();
      emit(AuthState.authenticated(userData));
    } catch (e) {
      emit(AuthState.error("Failed to complete signup: ${e.toString()}"));
    }
  }

  Future<void> _onResendEmailConfirmation(
    AuthEventResendEmailConfirmation event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final uniqueId = DateTime.now().millisecondsSinceEpoch;
    await repository.resendEmailConfirmationLink(event.email);
    emit(AuthState.otpResent(resendId: uniqueId));
  }

  Future<void> _onResendEmailConfirmationSignIn(
    AuthEventResendEmailConfirmationSignIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final uniqueId = DateTime.now().millisecondsSinceEpoch;
    await repository.resendEmailConfirmationLinkfromSignIn(event.email);
    emit(AuthState.otpResent(resendId: uniqueId));
  }
}
