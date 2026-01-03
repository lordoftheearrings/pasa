import 'package:pasa/core/components/buttons/app_outlinedbutton.dart';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_images.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pasa/config/router/app_routes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: Image.asset(AppImages.helmet, fit: BoxFit.contain),
                  ),
                  SizedBox(height: 16.0),
                  const AppText(
                    label: 'Redefining Road Safety',
                    style: AppTextStyles.secondaryColorText,
                  ),
                  SizedBox(height: 60.0),
                  AppOutlinedbutton(
                    label: 'SignUp to PASA',
                    onPressed: () {
                      context.pushNamed(AppRoutes.signUpForm.name);
                    },
                    leading: Image.asset(
                      AppImages.emailIcon,
                      height: 24,
                      width: 24,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  AppOutlinedbutton(
                    label: 'Sign up with Google',
                    onPressed: () {},
                    leading: Image.asset(
                      AppImages.googleLogo,
                      height: 24,
                      width: 24,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "By creating account you agree to PASA's\n",
                          style: AppTextStyles.bodyTextSemiBold,
                        ),
                        TextSpan(
                          text: "Terms and Conditions",
                          style: AppTextStyles.primaryColorText16.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(
                          text: " & ",
                          style: AppTextStyles.bodyTextSemiBold,
                        ),
                        TextSpan(
                          text: "Privacy Policy",
                          style: AppTextStyles.primaryColorText16.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                ],
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
                const AppText(label: "Already have an account?"),
                InkWell(
                  onTap: () {
                    context.goNamed(AppRoutes.signIn.name);
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
