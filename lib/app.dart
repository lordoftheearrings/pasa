import 'package:pasa/core/components/messengers/connectivity_listener.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/services/user_session_service.dart';
import 'package:pasa/core/top_level/di.dart';
import 'package:pasa/feature/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_bloc.dart';
import 'package:pasa/feature/auth/bloc/signup_bloc/signup_event.dart';
import 'package:pasa/feature/auth/repositories/auth_repository.dart';
import 'package:pasa/feature/auth/repositories/base_auth_repository.dart';
import 'package:pasa/feature/auth/services/base_auth_services.dart';
import 'package:pasa/feature/auth/services/signup_service.dart';
import 'package:flutter/material.dart';
import 'package:pasa/config/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BaseAuthRepository>(
          create: (context) =>
              AuthRepository(authService: getIt<BaseAuthServices>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              context.read<BaseAuthRepository>(),
              getIt<UserSessionService>(),
              getIt<SignupService>(),
            ),
          ),
          BlocProvider<SignupBloc>(
            create: (context) =>
                SignupBloc(getIt<SignupService>())
                  ..add(const SignupEvent.loadInitialData()),
          ),
        ],
        child: Builder(
          builder: (context) {
            final authBloc = context.read<AuthBloc>();

            return MaterialApp.router(
              routerConfig: appRouter(authBloc),
              themeMode: ThemeMode.dark,
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: AppColors.black,
                canvasColor: AppColors.black,
              ),
              builder: (context, child) {
                return ConnectivityListener(child: child!);
              },
            );
          },
        ),
      ),
    );
  }
}
