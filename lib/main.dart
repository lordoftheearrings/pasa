import 'package:pasa/core/top_level/di.dart';
import 'package:pasa/core/top_level/supabase_env.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: 'https://feeijoergvbgaefybina.supabase.co', anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZlZWlqb2VyZ3ZiZ2FlZnliaW5hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjcxOTA1ODQsImV4cCI6MjA4Mjc2NjU4NH0.QwH_BTp_MAIKzAserP_o6evbXg5UlQNHy3_am2SscBw');
  await configDependncies();
  runApp(App());
}
 