import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const DocScanApp());
}

class DocScanApp extends StatelessWidget {
  const DocScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocScan',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
