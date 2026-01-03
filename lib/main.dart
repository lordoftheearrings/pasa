import 'package:pasa/core/top_level/di.dart';
import 'package:pasa/core/top_level/supabase_env.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  await configDependncies();
  runApp(App());
}
