import 'package:pasa/feature/auth/utils/auth_constants.dart';

class AuthHelper {
  static String? notNullValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "This field can't be empty";
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (!isValidPhone(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateEmailorPhone(String? value) {
    if (value == null || value.isEmpty) {
      return "This field can't be empty";
    }
    if (!isValidPhone(value) && !isValidEmail(value)) {
      return 'Please enter a valid email or phone number';
    }
    return null;
  }

  static String? validatePassword(
    String? value, {
    bool reqStrengthCheck = false,
  }) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (reqStrengthCheck && !hasStrongPassword(value) && !hasReqLength(value)) {
      return "Password doesn't meet strength rules";
    }
    return null;
  }

  //Private Methods
  static bool isValidEmail(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return AuthConstants.emailRegex.hasMatch(value);
  }

  static bool isValidPhone(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return AuthConstants.phoneRegex.hasMatch(value);
  }

  static bool hasReqLength(String value) {
    if (value.length >= AuthConstants.minPWLength &&
        value.length <= AuthConstants.maxPWLength) {
      return true;
    } else {
      return false;
    }
  }

  static bool hasStrongPassword(String value) {
    final hasUppercase = AuthConstants.upperCase.hasMatch(value);
    final hasLowercase = AuthConstants.lowerCase.hasMatch(value);
    final hasNumber = AuthConstants.number.hasMatch(value);
    final hasSpecialchar = AuthConstants.specialChar.hasMatch(value);
    return hasUppercase && hasLowercase && hasSpecialchar && hasNumber;
  }
}
