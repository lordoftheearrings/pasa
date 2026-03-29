import 'package:pasa/core/components/messengers/app_snackbar.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_event.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_state.dart';
import 'package:pasa/feature/auth/components/password_with_confirmation.dart';
import 'package:go_router/go_router.dart';
import 'package:pasa/config/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:pasa/core/components/buttons/app_button.dart';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String pw = '';
  ValueNotifier<bool> isPasswordValid = ValueNotifier<bool>(false);

  @override
  void dispose() {
    isPasswordValid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.black,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: AppColors.black,
        title: AppText(
          label: 'Set New Password',
          style: AppTextStyles.primaryColorText16.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
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
                SizedBox(height: 32.0),
                AppText(
                  label:
                      'Your new password must be different from previous used passwords.',
                  style: AppTextStyles.bodyText16,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 32.0),
                PasswordWithConfirmation(
                  onPasswordConfirmed: (finalPw) {
                    pw = finalPw ?? '';
                    isPasswordValid.value = finalPw != null;
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
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthPasswordUpdated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AppSnackbar.showSuccess(
                    context,
                    'Password updated! Please sign in again',
                  );
                  context.goNamed(AppRoutes.signIn.name);
                });
              } else if (state is AuthError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AppSnackbar.showError(context, state.message);
                });
              }
            },
            builder: (context, state) {
              final loading = state is AuthLoading;

              return ValueListenableBuilder(
                valueListenable: isPasswordValid,
                builder: (context, isValid, child) {
                  return AppButton(
                    label: 'Change Password',
                    isLoading: loading,
                    isDisabled: !isValid,
                    onPressed: isValid
                        ? () {
                            context.read<AuthBloc>().add(
                              AuthEvent.updatePassword(password: pw.trim()),
                            );
                          }
                        : null,
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
