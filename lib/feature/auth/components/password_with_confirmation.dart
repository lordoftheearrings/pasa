import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:pasa/feature/auth/components/password_formfield.dart';
import 'package:pasa/feature/auth/utils/auth_constants.dart';
import 'package:pasa/feature/auth/utils/auth_helper.dart';
import 'package:flutter/material.dart';

class PasswordWithConfirmation extends StatefulWidget {
  final Function(String? confirmedPassword) onPasswordConfirmed;
  const PasswordWithConfirmation({
    super.key,
    required this.onPasswordConfirmed,
  });

  @override
  State<PasswordWithConfirmation> createState() =>
      _PasswordWithConfirmationState();
}

class _PasswordWithConfirmationState extends State<PasswordWithConfirmation> {
  final _pwController = TextEditingController();
  final _confirmController = TextEditingController();
  final _pwWithConfirmationFormKey = GlobalKey<FormState>();

  bool hasReqLength = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;
  bool passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    _pwController.addListener(_validateLive);
    _confirmController.addListener(_validateLive);
  }

  @override
  void dispose() {
    _pwController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _validateLive() {
    final pw = _pwController.text.trim();
    final confirm = _confirmController.text.trim();

    setState(() {
      hasReqLength = AuthHelper.hasReqLength(pw);
      hasUppercase = AuthConstants.upperCase.hasMatch(pw);
      hasLowercase = AuthConstants.lowerCase.hasMatch(pw);
      hasNumber = AuthConstants.number.hasMatch(pw);
      hasSpecialChar = AuthConstants.specialChar.hasMatch(pw);
      passwordsMatch = pw.isNotEmpty && pw == confirm;
    });

    if (hasReqLength &&
        hasUppercase &&
        hasLowercase &&
        hasNumber &&
        hasSpecialChar &&
        passwordsMatch) {
      widget.onPasswordConfirmed(pw);
    } else {
      widget.onPasswordConfirmed(null);
    }
  }

  Widget _buildRule(String text, bool isValid, int number) {
    return Row(
      children: [
        if (isValid)
          Icon(Icons.check_circle, size: 18, color: AppColors.success),
        if (!isValid)
          AppText(
            label: '$number.',
            style: AppTextStyles.greyedOutText,
            textAlign: TextAlign.start,
          ),
        const SizedBox(width: 6),
        Expanded(
          child: AppText(
            label: text,
            textAlign: TextAlign.start,
            style: isValid
                ? AppTextStyles.successText
                : AppTextStyles.greyedOutText,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _pwWithConfirmationFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRule(
            "Should contain at least one capital letter.",
            hasUppercase,
            1,
          ),
          _buildRule(
            "Should contain at least one lowercase letter.",
            hasLowercase,
            2,
          ),
          _buildRule(
            "Should contain at least one special character.",
            hasSpecialChar,
            3,
          ),
          _buildRule("Should contain at least one number.", hasNumber, 4),
          _buildRule(
            "Password must be  between [${AuthConstants.minPWLength}-${AuthConstants.maxPWLength}] characters",
            hasReqLength,
            5,
          ),
          const SizedBox(height: 24),
          PasswordFormfield(
            requireStrengthCheck: true,
            controller: _pwController,
          ),
          const SizedBox(height: 16),
          PasswordFormfield(
            labelText: 'Confirm Password',
            controller: _confirmController,
            requireStrengthCheck: true,
          ),
          const SizedBox(height: 16),
          _pwController.text.isNotEmpty && _confirmController.text.isNotEmpty
              ? passwordsMatch
                    ? _buildRule('Passwords Match', passwordsMatch, 0)
                    : AppText(
                        label: "Passwords do not match",
                        style: AppTextStyles.errorText,
                      )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
