import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'home_screen.dart';

// Screen 5: Create account
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  void _createAccount() {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      showMsg(context, 'Please fill all fields');
      return;
    }
    if (!email.contains('@')) {
      showMsg(context, 'Enter a valid email');
      return;
    }
    if (pass.length < 6) {
      showMsg(context, 'Password must be at least 6 characters');
      return;
    }

    // User ka naam/email save (profile aur settings me dikhega)
    DocStore.userName = name;
    DocStore.userEmail = email;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
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
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              const Text('Create account',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 4),
              const Text('start scanning in seconds',
                  style: TextStyle(color: AppColors.grey)),
              const SizedBox(height: 32),
              AppTextField(label: 'full name', controller: _nameCtrl),
              const SizedBox(height: 22),
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
              const SizedBox(height: 28),
              GradientButton(text: 'create account', onTap: _createAccount),
            ],
          ),
        ),
      ),
    );
  }
}
