import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const TextScannerApp());
}

class TextScannerApp extends StatelessWidget {
  const TextScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Document Scanner App',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: const SplashScreen(),
    );
  }
}