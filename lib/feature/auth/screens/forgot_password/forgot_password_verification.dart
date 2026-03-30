import 'package:pasa/config/router/app_routes.dart';
import 'package:pasa/core/components/messengers/app_snackbar.dart';
import 'package:pasa/core/components/messengers/countdown_timer.dart';
import 'package:pasa/core/components/messengers/dialog_box.dart';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_event.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_state.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_bloc.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordVerification extends StatefulWidget {
  const ForgotPasswordVerification({super.key});

  @override
  State<ForgotPasswordVerification> createState() =>
      _ForgotPasswordVerificationState();
}

class _ForgotPasswordVerificationState
    extends State<ForgotPasswordVerification> {
  final ValueNotifier<bool> isButtonDisabled = ValueNotifier(true);
  final CountdownController _controller = CountdownController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 24),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthResetPasswordSent) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppSnackbar.showSuccess(
                      context,
                      'Reset Password Email Sent',
                    );
                  });
                } else if (state is AuthError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppSnackbar.showError(context, state.message);
                  });
                }
              },
              builder: (context, state) {
                final String? email = state is AuthResetPasswordSent
                    ? state.email
                    : null;
                return Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.14),
                    AppText(
                      label: "Check Your Email",
                      style: AppTextStyles.heading2,
                    ),
                    SizedBox(height: 32),
                    AppText(label: 'We have sent reset password email to'),
                    SizedBox(height: 8),
                    AppText(
                      label: email ?? 'No Email Available',
                      style: AppTextStyles.primaryColorText16.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    AppText(label: "Tap below to check your email"),
                    SizedBox(height: 32),
                    InkWell(
                      onTap: () {
                        context.read<SignupBloc>().add(
                          SignupEvent.launchemail(),
                        );
                      },
                      child: AppText(
                        label: "Check Email",
                        style: AppTextStyles.hyperlinkText,
                      ),
                    ),
                    SizedBox(height: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CountdownTimer(
                          controller: _controller,
                          initialDuration: const Duration(seconds: 120),  
                          onTimerEnd: () => isButtonDisabled.value = false,
                          autoStart: true,
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              label: "Didn't receive the email? ",
                              style: AppTextStyles.bodyText14,
                            ),
                            SizedBox(width: 8.0),
                            ValueListenableBuilder(
                              valueListenable: isButtonDisabled,
                              builder: (context, value, child) {
                                return value
                                    ? AppText(
                                        label: 'Resend',
                                        underline: true,
                                        style: AppTextStyles.greyedOutText,
                                      )
                                    : InkWell(
                                        onTap: () {
                                          isButtonDisabled.value = true;
                                          _controller.restart();
                                          if (email == null) {
                                            AppSnackbar.showError(
                                              context,
                                              'No email available',
                                            );
                                            return;
                                          }
                                          context.read<AuthBloc>().add(
                                            AuthEvent.resetPasswordEmail(
                                              email: email,
                                            ),
                                          );
                                        },
                                        child: AppText(
                                          label: "Resend",
                                          underline: true,
                                          style: AppTextStyles
                                              .primaryColorText14
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppText(label: "Already have an account?"),
                InkWell(
                  onTap: () async {
                    final save = await AppDialogBox.show(
                      context,
                      title: 'Are you sure?',
                      content: 'Do you want to go sign in instead?',
                      confirmText: 'Yes',
                      cancelText: 'No',
                    );
                    if (save == true) {
                      if (!context.mounted) return;
                      context.goNamed(AppRoutes.signIn.name);
                    } else if (save == false || save == null) {
                      if (!context.mounted) return;
                      return;
                    }
                  },
                  child: AppText(
                    label: " Sign In",
                    style: AppTextStyles.primaryColorText14.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ],
      ),
    );
  }
}
