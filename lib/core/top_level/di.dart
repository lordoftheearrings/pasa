import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pasa/core/services/connectivity_service.dart';
import 'package:pasa/core/services/crash_service.dart';
import 'package:pasa/core/services/shared_pref_service.dart';
import 'package:pasa/core/services/user_session_service.dart';
import 'package:pasa/feature/auth/services/auth_services.dart';
import 'package:pasa/feature/auth/services/base_auth_services.dart';
import 'package:pasa/feature/auth/services/signup_service.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pasa/whole_app/lib/ble_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> configDependncies() async {
  final prefs = await SharedPreferences.getInstance();
  final supabaseClient = Supabase.instance.client;

  getIt.registerSingleton<SupabaseClient>(supabaseClient);
  getIt.registerSingleton(CrashService());
  getIt.registerSingleton(BleController());

  getIt.registerSingleton<BaseAuthServices>(
    AuthServices(getIt<SupabaseClient>()),
  );
  getIt.registerSingleton<UserSessionService>(
    UserSessionService(getIt<SupabaseClient>()),
  );
  getIt.registerSingleton<ConnectivityService>(
    ConnectivityService(
      connectivity: Connectivity(),
      internetChecker: InternetConnection(),
    ),
  );
  getIt.registerSingleton<SharedPrefService>(SharedPrefService(prefs));
  getIt.registerLazySingleton<SignupService>(
    () => SignupService(getIt<SharedPrefService>()),
  );
}
