import 'package:pasa/config/router/app_routes.dart';
import 'package:pasa/core/components/messengers/app_snackbar.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_event.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_state.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_bloc.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_event.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_state.dart';
import 'package:pasa/feature/auth/components/password_with_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:pasa/core/components/buttons/app_button.dart';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupSetPasswordScreen extends StatefulWidget {
  const SignupSetPasswordScreen({super.key});

  @override
  State<SignupSetPasswordScreen> createState() =>
      _SignupSetPasswordScreenState();
}

class _SignupSetPasswordScreenState extends State<SignupSetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 24),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label:
                      'Create a strong password and follow the rule provided.',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 40.0),
                BlocBuilder<SignupBloc, SignupState>(
                  builder: (context, state) {
                    return PasswordWithConfirmation(
                      onPasswordConfirmed: (finalPw) {
                        context.read<SignupBloc>().add(
                          SignupEvent.submitSignup(finalPw),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: AppColors.black,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
          child: BlocBuilder<SignupBloc, SignupState>(
            builder: (context, signupstate) {
              final isDisabled =
                  (signupstate.password == null) ||
                  (signupstate.signupData.email == null);

              return BlocConsumer<AuthBloc, AuthState>(
                listener: (context, authstate) {
                  if (authstate is AuthVerificationNeeded &&
                      authstate.user.id.isNotEmpty) {
                    context.pushNamed(AppRoutes.signUpVerification.name);
                  } else if (authstate is AuthError) {
                    AppSnackbar.showError(context, authstate.message);
                  }
                },
                builder: (context, authstate) {
                  final loading = authstate is AuthLoading;
                  return AppButton(
                    label: 'Sign Up',
                    isLoading: loading,
                    onPressed: isDisabled
                        ? null
                        : () {
                            context.read<AuthBloc>().add(
                              AuthEventSignUp(
                                password: signupstate.password!,
                                signupData: signupstate.signupData,
                              ),
                            );
                          },
                    isDisabled: isDisabled,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
