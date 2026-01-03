import 'package:pasa/core/components/buttons/app_outlinedbutton.dart';
import 'package:pasa/core/components/messengers/app_snackbar.dart';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/components/messengers/dialog_box.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:pasa/core/top_level/di.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_event.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_state.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_bloc.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_event.dart';
import 'package:pasa/feature/auth/components/password_formfield.dart';
import 'package:pasa/feature/auth/services/signup_service.dart';
import 'package:flutter/material.dart';
import 'package:pasa/core/constants/app_images.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasa/feature/auth/components/forgot_pw_sheet.dart';
import 'package:pasa/config/router/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:pasa/feature/auth/utils/auth_helper.dart';
import 'package:pasa/core/components/inputfield/inputfield.dart';
import 'package:pasa/core/components/buttons/app_button.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  late final SignupService signupService;
  final GlobalKey<FormState> _signinFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    signupService = getIt<SignupService>();
    if (signupService.hasData == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showReloadDialog(context);
      });
    }
  }

  void _showReloadDialog(BuildContext context) async {
    final save = await AppDialogBox.show(
      context,
      title: 'Reload your data?',
      content: 'Do you want to reload the information you entered previously?',
      confirmText: 'Reload & SignUp',
      cancelText: 'Clear Info',
    );
    if (save == true) {
      if (!context.mounted) return;
      context.pushNamed(AppRoutes.signUpForm.name);
    } else if (save == false || save == null) {
      if (!context.mounted) return;

      context.read<SignupBloc>().add(SignupEvent.clear());
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: context.read<AuthBloc>(),
      listener: (context, state) {
        if (state is AuthVerificationNeededFromSignIn &&
            state.email.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed(AppRoutes.signInVerification.name);
          });
        } else if (state is AuthAuthenticated && state.user.id.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppSnackbar.showSuccess(context, 'Login Successful');
          });
        } else if (state is AuthError) {
          AppSnackbar.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _signinFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      SizedBox(
                        height: 140,
                        width: 140,
                        child: Image.asset(AppImages.logo, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 16.0),
                      const AppText(
                        label: 'Welcome, to PASA',
                        style: AppTextStyles.heading1,
                      ),
                      const SizedBox(height: 16.0),
                      InputField(
                        labelText: "Phone number or email",
                        validator: (value) =>
                            AuthHelper.validateEmailorPhone(value),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16.0),
                      PasswordFormfield(controller: passwordController),
                      const SizedBox(height: 16.0),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final loading = state is AuthLoading;
                          return AppButton(
                            label: 'Sign In',
                            isLoading: loading,
                            onPressed: () {
                              if (_signinFormKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  AuthEventSignIn(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),
                      InkWell(
                        onTap: () {
                          showForgotPasswordSheet(context);
                        },
                        child: const AppText(
                          label: 'Forgot password?',
                          style: AppTextStyles.primaryColorText16,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Divider(
                                color: AppColors.white,
                                thickness: 1,
                                endIndent: 10,
                              ),
                            ),
                            const AppText(
                              label: 'OR',
                              style: AppTextStyles.bodyText16,
                            ),
                            Expanded(
                              flex: 4,
                              child: Divider(
                                color: AppColors.white,
                                thickness: 1,
                                indent: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const AppText(
                        label: 'Continue with',
                        style: AppTextStyles.bodyText16,
                      ),
                      const SizedBox(height: 8.0),
                      AppOutlinedbutton(
                        label: 'Sign in with Google',
                        onPressed: () {
                          context.pushNamed(AppRoutes.home.name);
                        },
                        leading: Image.asset(
                          AppImages.googleLogo,
                          height: 24,
                          width: 24,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                ),
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
                  const AppText(label: "Don't have an account?"),
                  InkWell(
                    onTap: () {
                      context.goNamed(AppRoutes.signUp.name);
                    },
                    child: AppText(
                      label: " Sign up",
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
      ),
    );
  }
}
