enum AppRoutes {
  signIn,
  signInVerification,
  signUp,
  signUpForm,
  signUpPw,
  signUpVerification,
  signUpCompletion,
  profileCompletion,
  home,
  safety,
  rides,
  maps;

  String get path {
    switch (this) {
      case AppRoutes.signIn:
        return '/sign-in';
      case AppRoutes.signInVerification:
        return '/sign-in-verification';
      case AppRoutes.signUp:
        return '/sign-up';
      case AppRoutes.signUpForm:
        return '/sign-up-form';
      case AppRoutes.signUpPw:
        return '/sign-up-password';
      case AppRoutes.signUpVerification:
        return '/sign-up-verification';
      case AppRoutes.signUpCompletion:
        return '/sign-up-completion';
      case AppRoutes.profileCompletion:
        return '/profile-completion';
      case AppRoutes.home:
        return '/';
      case AppRoutes.safety:
        return '/safety';
      case AppRoutes.rides:
        return '/rides';
      case AppRoutes.maps:
        return '/maps';
    }
  }
}
