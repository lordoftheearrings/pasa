import 'package:pasa/config/router/app_routes.dart';
import 'package:pasa/core/components/messengers/app_snackbar.dart';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:pasa/core/services/user_session_service.dart';
import 'package:pasa/core/top_level/di.dart';
import 'package:pasa/core/urls/app_link_urls.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupCompletionScreen extends StatefulWidget {
  final Uri uri;

  const SignupCompletionScreen({super.key, required this.uri});

  @override
  State<SignupCompletionScreen> createState() => _SignupCompletionScreenState();
}

class _SignupCompletionScreenState extends State<SignupCompletionScreen> {
  final sessionService = getIt<UserSessionService>();

  @override
  void initState() {
    super.initState();
    _process();
  }

  Future<void> _process() async {
    try {
      await sessionService.handleDeepLink(widget.uri);
      final session = await sessionService.sessionStream.firstWhere(
        (s) => s != null,
        orElse: () => throw Exception("No session after deep link"),
      );
      if (!mounted) return;
      if (session != null) {
        if (widget.uri.path == '/${AppLinkUrls.verifyUser}') {
          context.read<AuthBloc>().add(
            AuthEvent.completeSignup(session: session),
          );
        } else if (widget.uri.path ==
            '/${AppLinkUrls.verifyUserbutHasNoProfile}') {
          context.goNamed(AppRoutes.profileCompletion.name);
        } else if (widget.uri.path == '/${AppLinkUrls.resetPassword}') {
          context.goNamed(AppRoutes.forgotPassword.name);
        }
      } else {
        AppSnackbar.showError(context, 'No User Session');
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 8.0),
            if (widget.uri.path == '/${AppLinkUrls.verifyUser}')
              AppText(
                label: 'Completing Your Profile',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.primary,
                ),
              ),
            if (widget.uri.path == '/${AppLinkUrls.resetPassword}')
              AppText(
                label: 'Verifying',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.primary,
                ),
              ),
            if (widget.uri.path == '/${AppLinkUrls.verifyUserbutHasNoProfile}')
              AppText(
                label: 'Verifying User',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
