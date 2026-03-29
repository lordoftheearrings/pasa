import 'package:pasa/config/router/app_routes.dart';
import 'package:pasa/core/components/messengers/app_snackbar.dart';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:pasa/core/components/inputfield/inputfield.dart';
import 'package:pasa/core/components/buttons/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_event.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_state.dart';

class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({super.key});

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthResetPasswordSent) {
          context.pop(); // Close the bottom sheet
          context.pushNamed(AppRoutes.forgotPasswordVerification.name);
        } else if (state is AuthError) {
          AppSnackbar.showError(context, state.message);
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.height * 0.02,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.hint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const AppText(
                    label: 'Forgot your password?',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: 8),
                  const AppText(
                    label:
                        'Please enter your email address where you would like to receive the reset link.',
                    style: AppTextStyles.greyedOutText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  InputField(
                    labelText: "Email",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      final regex = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                      if (!regex.hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return AppButton(
                          label: 'Send',
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                AuthEvent.resetPasswordEmail(
                                  email: _emailController.text.trim(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showForgotPasswordSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (_) => BlocProvider.value(
      value: context.read<AuthBloc>(),
      child: const ForgotPasswordSheet(),
    ),
  );
}
