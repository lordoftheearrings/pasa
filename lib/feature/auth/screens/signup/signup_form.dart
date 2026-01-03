import 'package:pasa/config/router/app_routes.dart';
import 'package:pasa/core/components/buttons/app_button.dart';
import 'package:pasa/core/components/selectors/date_selector.dart';
import 'package:pasa/core/components/selectors/gender_radiobuttons.dart';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/components/messengers/dialog_box.dart';
import 'package:pasa/core/components/inputfield/inputfield.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_bloc.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_event.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_state.dart';
import 'package:pasa/feature/auth/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupFormScreen extends StatefulWidget {
  const SignupFormScreen({super.key});

  @override
  State<SignupFormScreen> createState() => _SignupFormScreenState();
}

class _SignupFormScreenState extends State<SignupFormScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _phonecontroller.dispose();
    _namecontroller.dispose();
    super.dispose();
  }

  void handleBack(BuildContext context) async {
    final signupData = context.read<SignupBloc>().state.signupData;
    final hasData =
        (signupData.phone?.isNotEmpty ?? false) ||
        (signupData.email?.isNotEmpty ?? false);

    if (!hasData) {
      context.pop();
      return;
    }

    final save = await AppDialogBox.show(
      context,
      title: 'Save your data?',
      content: 'Do you want to save the information you entered?',
    );
    if (save == null) {
      return;
    } else if (save == false) {
      if (!context.mounted) return;

      context.read<SignupBloc>().add(SignupEvent.clear());
    }
    if (!context.mounted) return;

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => handleBack(context),

      child: Form(
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _signupFormKey,
        child: Scaffold(
          backgroundColor: AppColors.black,
          appBar: AppBar(
            backgroundColor: AppColors.black,
            leading: IconButton(
              icon: const Icon(Icons.chevron_left, size: 24),
              onPressed: () => handleBack(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocConsumer<SignupBloc, SignupState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          label: 'Email Address to Sign Up',
                          style: AppTextStyles.heading3,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 16.0),
                        InputField(
                          labelText: "Email",
                          controller: _emailcontroller,
                          validator: (value) => AuthHelper.validateEmail(value),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16.0),
                        AppText(
                          label: 'Phone Number',
                          style: AppTextStyles.heading3,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 16.0),
                        InputField(
                          labelText: "Phone Number",
                          controller: _phonecontroller,
                          validator: (value) => AuthHelper.validatePhone(value),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16.0),
                        AppText(
                          label: 'Full Name',
                          style: AppTextStyles.heading3,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 16.0),
                        InputField(
                          labelText: "Full Name",
                          controller: _namecontroller,
                          validator: (value) =>
                              AuthHelper.notNullValidation(value),
                        ),
                        const SizedBox(height: 16.0),
                        AppText(
                          label: 'Date of Birth',
                          style: AppTextStyles.heading3,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 16.0),
                        DateSelector(
                          label: 'Date of Birth',
                          onDateSelected: (value) {},
                        ),
                        const SizedBox(height: 16.0),
                        AppText(
                          label: 'Gender',
                          style: AppTextStyles.heading3,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 16.0),
                        GenderSelection(onChanged: (gender) {}),
                        const SizedBox(height: 16.0),
                        AppText(
                          label: 'Blood Group',
                          style: AppTextStyles.heading3,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 16.0),
                        InputField(
                          labelText: "Full Name",
                          controller: _namecontroller,
                          validator: (value) =>
                              AuthHelper.notNullValidation(value),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          bottomSheet: Container(
            color: AppColors.black,
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
              child: AppButton(
                label: 'Next',
                onPressed: () {
                  if (_signupFormKey.currentState!.validate()) {
                    context.pushNamed(AppRoutes.signUpPw.name);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
