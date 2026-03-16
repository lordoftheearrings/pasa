import 'package:pasa/core/components/buttons/app_button.dart';
import 'package:pasa/core/components/messengers/app_snackbar.dart';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_images.dart';
import 'package:pasa/core/top_level/di.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_state.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_bloc.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_event.dart';
import 'package:pasa/feature/auth/services/signup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final session = getIt<SupabaseClient>();
  final ValueNotifier<bool> _helmetWear = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _alcohol = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _ready = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      final signupService = getIt<SignupService>();

      if (authState is AuthAuthenticated &&
          signupService.wasSignupJustCompleted()) {
        AppSnackbar.showSuccess(context, 'Signup successful');
        context.read<SignupBloc>().add(const SignupEvent.clear());
      }
    });
    _helmetWear.addListener(_updateReady);
    _alcohol.addListener(_updateReady);

    _updateReady();
  }

  void _updateReady() {
    _ready.value = _helmetWear.value && _alcohol.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        toolbarHeight: 100,
        title: Row(
          children: [
            CircleAvatar(radius: 30, backgroundColor: AppColors.primary),
            SizedBox(width: 8),
            Expanded(
              child: IconButton(
                onPressed: () {
                  session.auth.signOut();
                },
                icon: Icon(Icons.notifications_none_outlined, size: 35),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                AppText(label: session.auth.currentUser?.email ?? ''),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Image.asset(AppImages.logo, fit: BoxFit.contain),
                ),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Image.asset(AppImages.appName, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.black,
                    AppColors.black,
                    AppColors.primary,
                    AppColors.black,
                    AppColors.black,
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: -MediaQuery.of(context).size.width * 0.01,
              child: Opacity(
                opacity: 0.8,
                child: SizedBox(
                  height: 450,
                  width: 300,
                  child: Image.asset(AppImages.helmetHome, fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    AppButton(
                      label: 'WEAR',
                      onPressed: () {
                        _helmetWear.value = !_helmetWear.value;
                      },
                      width: 50,
                      shouldUseFullWidth: false,
                      color: AppColors.tertiary,
                      borderRadius: 32,
                      textcolor: AppColors.white,
                    ),
                    SizedBox(height: 16),
                    AppButton(
                      label: 'ALCOHOL',
                      onPressed: () {
                        _alcohol.value = !_alcohol.value;
                      },
                      width: 50,
                      shouldUseFullWidth: false,
                      color: AppColors.tertiary,
                      borderRadius: 32,
                      textcolor: AppColors.white,
                    ),
                    SizedBox(height: 16),
                    AppButton(
                      label: 'SOS',
                      onPressed: () {},
                      width: 50,
                      shouldUseFullWidth: false,
                      color: AppColors.tertiary,
                      borderRadius: 32,
                      textcolor: AppColors.white,
                    ),
                    SizedBox(height: 16),
                    Icon(
                      Icons.bluetooth_disabled_outlined,
                      color: AppColors.error,
                    ),
                    SizedBox(height: 16),
                    Icon(Icons.battery_saver_rounded, color: AppColors.success),
                  ],
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GridView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                      ),
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable: _helmetWear,
                                      builder: (context, value, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: value
                                                ? AppColors.primary
                                                : AppColors.tertiary,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  value
                                                      ? AppImages.helmet
                                                      : AppImages.noHelmet,
                                                  height: 50,
                                                ),
                                                SizedBox(height: 8),
                                                AppText(
                                                  label: value
                                                      ? 'Helmet Worn'
                                                      : 'No Helmet',
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: _alcohol,
                                      builder: (context, value, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: value
                                                ? AppColors.primary
                                                : AppColors.tertiary,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  value
                                                      ? AppImages.noAlcohol
                                                      : AppImages.yesAlcohol,
                                                  height: 50,
                                                ),
                                                SizedBox(height: 8),
                                                Expanded(
                                                  child: AppText(
                                                    label: value
                                                        ? 'No Alcohol'
                                                        : 'AlcoholDetected',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: _ready,
                                      builder: (context, value, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: value
                                                ? AppColors.primary
                                                : AppColors.secondary,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  value
                                                      ? AppImages.appName
                                                      : AppImages.logo,
                                                  height: 50,
                                                ),
                                                SizedBox(height: 8),
                                                AppText(
                                                  label: value
                                                      ? 'Ready'
                                                      : 'Not Ready',
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                ValueListenableBuilder(
                                  valueListenable: _ready,
                                  builder: (context, value, child) {
                                    return AppButton(
                                      isDisabled: !_ready.value,
                                      label: 'START',
                                      textcolor: AppColors.white,
                                      onPressed: () {},
                                      height: 70,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
            ),
          ],
        ),
      ),
    );
  }
}
