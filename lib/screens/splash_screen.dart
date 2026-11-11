import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'onboarding_screen.dart';

// Screen 1: Splash
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 2 second baad onboarding par chale jao
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Icon(Icons.crop_free,
                    size: 80, color: AppColors.pink),
              ),
              const SizedBox(height: 32),
              const Text(
                'DocScan',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Scan. Enhance. Save',
                style: TextStyle(fontSize: 16, color: AppColors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
