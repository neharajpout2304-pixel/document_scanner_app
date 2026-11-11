import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

// Screen 6: Welcome Back / Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  void _login() {
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.isEmpty) {
      showMsg(context, 'Enter email and password');
      return;
    }
    DocStore.userEmail = _emailCtrl.text.trim();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Widget _socialButton(String letter) {
    return Expanded(
      child: GestureDetector(
        onTap: () => showMsg(context, 'Social login coming soon'),
        child: Container(
          height: 52,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(letter,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.description_outlined,
                    color: Colors.white, size: 34),
              ),
              const SizedBox(height: 28),
              const Text('Welcome Back',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 4),
              const Text('sign in to sync your scans',
                  style: TextStyle(color: AppColors.grey)),
              const SizedBox(height: 32),
              AppTextField(
                label: 'email',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 22),
              AppTextField(
                label: 'password',
                controller: _passCtrl,
                obscure: true,
              ),
              // Naya: forgot password link (screen 18)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen()),
                  ),
                  child: const Text('forgot password?',
                      style: TextStyle(color: AppColors.pink)),
                ),
              ),
              const SizedBox(height: 8),
              GradientButton(text: 'Login', onTap: _login),
              const SizedBox(height: 22),
              const Center(
                child: Text('or continue with',
                    style: TextStyle(color: AppColors.grey)),
              ),
              const SizedBox(height: 14),
              Row(children: [_socialButton('G'), _socialButton('Y')]),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("don't have an account? ",
                      style: TextStyle(color: AppColors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    ),
                    child: const Text('sign up',
                        style: TextStyle(
                            color: AppColors.pink,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
