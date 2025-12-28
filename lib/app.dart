import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pasa',
      home: Scaffold(
        appBar: AppBar(title: const Text('pasa')),
        body: Center(
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', width: 80, height: 80),
              Text('PASA APP'),
            ],
          ),
        ),
      ),
    );
  }
}
