import 'dart:async';
import 'package:pasa/core/components/navbar/bottom_navbar.dart';
import 'package:pasa/core/services/crash_service.dart';
import 'package:pasa/core/services/user_session_service.dart';
import 'package:pasa/core/top_level/di.dart';
import 'package:pasa/core/urls/app_link_urls.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:pasa/feature/auth/screens/forgot_password/forgot_password_verification.dart';
import 'package:pasa/feature/auth/screens/signin/signin_verification.dart';
import 'package:pasa/feature/auth/screens/signup/signup_completion.dart';
import 'package:pasa/feature/auth/screens/signup/signup_form.dart';
import 'package:pasa/feature/auth/screens/signup/signup_password.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:pasa/feature/maps/map_screen.dart';
// import 'package:pasa/feature/rides/rides_screen.dart';
// import 'package:pasa/feature/safety/safety_screen.dart';
import 'package:pasa/sugam_part/lib/ble_controller.dart';
import 'package:pasa/sugam_part/lib/details_page.dart';
import 'package:pasa/sugam_part/lib/home_page.dart';
import 'package:pasa/sugam_part/lib/map_page.dart';
import 'package:pasa/sugam_part/lib/status_page.dart';
import '../../feature/auth/screens/forgot_password/forgot_password_screen.dart';
import 'app_routes.dart';
import 'package:pasa/feature/auth/screens/signin/signin_screen.dart';
import 'package:pasa/feature/auth/screens/signup/signup_screen.dart';
// import 'package:pasa/feature/home/home.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _safetyNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _ridesNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _mapsNavigatorKey = GlobalKey<NavigatorState>();

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscriptionSession;
  late final StreamSubscription _authSub;

  GoRouterRefreshStream(Stream<dynamic> stream, AuthBloc authBloc) {
    notifyListeners();
    _authSub = authBloc.stream.listen((_) => notifyListeners());
    _subscriptionSession = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscriptionSession.cancel();
    _authSub.cancel();
    super.dispose();
  }
}

final bleController = getIt<BleController>();
final sessionService = getIt<UserSessionService>();

final loginPaths = [
  AppRoutes.signIn.path,
  AppRoutes.signInVerification.path,
  AppRoutes.signUp.path,
  AppRoutes.signUpForm.path,
  AppRoutes.signUpPw.path,
  AppRoutes.signUpVerification.path,
  AppRoutes.signUpCompletion.path,
  AppRoutes.profileCompletion.path,
  '/${AppLinkUrls.verifyUser}',
  '/${AppLinkUrls.verifyUserbutHasNoProfile}',
  '/${AppLinkUrls.resetPassword}',
];
final authReqPaths = [
  AppRoutes.home.path,
  AppRoutes.safety.path,
  AppRoutes.rides.path,
  AppRoutes.maps.path,
];

GoRouter appRouter(AuthBloc authBloc) {
  return GoRouter(
    refreshListenable: GoRouterRefreshStream(
      getIt<UserSessionService>().sessionStream,
      authBloc,
    ),
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home.path,
    routes: [
      GoRoute(
        name: AppRoutes.signIn.name,
        path: AppRoutes.signIn.path,
        builder: (_, _) => SigninScreen(),
      ),
      GoRoute(
        name: AppRoutes.signInVerification.name,
        path: AppRoutes.signInVerification.path,
        builder: (_, _) => SigninVerification(),
      ),
      GoRoute(
        name: AppRoutes.signUp.name,
        path: AppRoutes.signUp.path,
        builder: (_, _) => SignupScreen(),
      ),
      GoRoute(
        name: AppRoutes.signUpForm.name,
        path: AppRoutes.signUpForm.path,
        builder: (_, _) => SignupFormScreen(),
      ),
      GoRoute(
        name: AppRoutes.signUpPw.name,
        path: AppRoutes.signUpPw.path,
        builder: (_, _) => SignupSetPasswordScreen(),
      ),
      GoRoute(
        path: '/${AppLinkUrls.resetPassword}',
        builder: (_, state) => SignupCompletionScreen(uri: state.uri),
      ),
      GoRoute(
        name: AppRoutes.forgotPassword.name,
        path: AppRoutes.forgotPassword.path,
        builder: (_, _) => ForgotPasswordScreen(),
      ),
      GoRoute(
        name: AppRoutes.forgotPasswordVerification.name,
        path: AppRoutes.forgotPasswordVerification.path,
        builder: (_, _) => ForgotPasswordVerification(),
      ),
      // GoRoute(
      //   name: AppRoutes.signUpVerification.name,
      //   path: AppRoutes.signUpVerification.path,
      //   builder: (_, _) => SignupVerification(),
      // ),
      // GoRoute(
      //   path: '/${AppLinkUrls.verifyUser}',
      //   builder: (_, state) => SignupCompletionScreen(uri: state.uri),
      // ),
      // GoRoute(
      //   path: '/${AppLinkUrls.verifyUserbutHasNoProfile}',
      //   builder: (_, state) => SignupCompletionScreen(uri: state.uri),
      // ),
      // GoRoute(
      //   name: AppRoutes.profileCompletion.name,
      //   path: AppRoutes.profileCompletion.path,
      //   builder: (_, _) => ProfileCompletionScreen(),
      // ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: AppBottomNavBar(
              navigationShell: navigationShell,
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                name: AppRoutes.home.name,
                path: AppRoutes.home.path,
                builder: (_, _) => HomePage(bleController: bleController),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _safetyNavigatorKey,
            routes: [
              GoRoute(
                name: AppRoutes.safety.name,
                path: AppRoutes.safety.path,
                // builder: (_, _) => CrashOverlay(crashService: CrashService()),
                builder: (_, _) => DetailsPage(bleController: bleController),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _ridesNavigatorKey,
            routes: [
              GoRoute(
                name: AppRoutes.rides.name,
                path: AppRoutes.rides.path,
                builder: (_, _) => StatusPage(bleController: bleController),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _mapsNavigatorKey,
            routes: [
              GoRoute(
                name: AppRoutes.maps.name,
                path: AppRoutes.maps.path,
                builder: (_, _) => MapPage(bleController: bleController),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) async {
      final session = sessionService.currentSession;
      final path = state.matchedLocation;
      final bool onLoginPath = loginPaths.contains(path);
      final bool onAuthReqPath = authReqPaths.contains(path);

      if (session == null) {
        if (onAuthReqPath) {
          return AppRoutes.signIn.path;
        }
        return null;
      }

      // Check if profile exists
      final hasProfile = await sessionService.hasProfile(session.user.id);

      if (!hasProfile) {
        // Allow staying on auth paths while profile is being created
        if (onAuthReqPath) {
          return AppRoutes.signUp.path;
        }
        return null;
      }

      // Session and Profile exist
      if (onLoginPath) {
        return AppRoutes.home.path;
      }

      return null;
    },
  );
}
