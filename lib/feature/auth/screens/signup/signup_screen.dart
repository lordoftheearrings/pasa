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
                  SizedBox(height: 80.0),
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
                  SizedBox(height: 32.0),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "By creating account you agree to PASA's\n\n",
                          style: AppTextStyles.bodyTextSemiBold,
                        ),

                        TextSpan(
                          text: "Privacy Policy",
                          style: AppTextStyles.primaryColorText16.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PrivacyPolicyPage(),
                                ),
                              );
                            },
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

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Privacy Policy",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Your privacy is important to us. This app collects the minimum data required to provide emergency assistance during accidents or incidents.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "What We Collect:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "- Your basic user information (name, phone number).\n"
                "- Location data during an active emergency event.\n"
                "- Emergency contact information that you provide.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "How We Use Your Data:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Your data is used solely to alert and notify your trusted emergency contacts in case of an accident. We do NOT share your data with any third parties beyond your designated contacts.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "By using this app, you agree to this privacy policy.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
