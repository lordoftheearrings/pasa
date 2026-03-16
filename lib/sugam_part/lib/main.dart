import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ble_controller.dart';
import 'smart_helmet_app.dart'; // ← CHANGED: Import SmartHelmetApp instead of HomePage

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://xajsuwxfdoqorqdzthrr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhhanN1d3hmZG9xb3JxZHp0aHJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg1ODI0NzQsImV4cCI6MjA4NDE1ODQ3NH0.QDNSn6tJZAApoBSYNpVmnKgnuZEClB_F583MS5FnRvg',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Create a SINGLE instance of BleController that will be shared
  late final BleController bleController;

  @override
  void initState() {
    super.initState();
    bleController = BleController();
  }

  @override
  void dispose() {
    bleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Helmet',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,

      // ✅ FIXED: Use SmartHelmetApp instead of HomePage
      // SmartHelmetApp contains the bottom navigation bar
      home: SmartHelmetApp(bleController: bleController),
    );
  }
}
