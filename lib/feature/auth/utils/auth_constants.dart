class AuthConstants {
  static final RegExp phoneRegex = RegExp(r'^\+?[0-9]{10,17}$');
  static final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp upperCase = RegExp(r'[A-Z]');
  static final RegExp lowerCase = RegExp(r'[a-z]');
  static final RegExp number = RegExp(r'[0-9]');
  static final RegExp specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  static final int minPWLength = 8;
  static final int maxPWLength = 15;
}
