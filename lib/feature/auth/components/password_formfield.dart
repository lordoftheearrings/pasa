import 'package:flutter/material.dart';
import 'package:pasa/core/components/inputfield/inputfield.dart';
import 'package:pasa/feature/auth/utils/auth_helper.dart';

class PasswordFormfield extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool requireStrengthCheck;

  const PasswordFormfield({
    super.key,
    this.labelText = 'Password',
    this.controller,
    this.requireStrengthCheck = false,
  });

  @override
  State<PasswordFormfield> createState() => _PasswordFormfieldState();
}

class _PasswordFormfieldState extends State<PasswordFormfield> {
  final ValueNotifier<bool> _obscureText = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _obscureText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _obscureText,
      builder: (context, obscure, child) {
        return InputField(
          obscureText: obscure,
          labelText: widget.labelText,
          controller: widget.controller,
          validator: (value) => AuthHelper.validatePassword(
            value,
            reqStrengthCheck: widget.requireStrengthCheck,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              _obscureText.value = !obscure;
            },
          ),
        );
      },
    );
  }
}
