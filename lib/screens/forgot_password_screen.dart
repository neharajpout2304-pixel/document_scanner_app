import 'package:flutter/material.dart';
import 'app_theme.dart';

// Screen 18: Forgot password
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _sent = false; // false = email form, true = "link bhej diya" message

  void _sendLink() {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      showMsg(context, 'Enter a valid email');
      return;
    }
    // Asli app me yahan server ko request jati hai. Abhi sirf screen badalti hai.
    setState(() => _sent = true);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
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
              const ScreenHeader(title: 'forgot password'),
              const SizedBox(height: 32),
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.field,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Icon(
                    _sent ? Icons.mark_email_read_outlined : Icons.lock_reset,
                    size: 52,
                    color: AppColors.pink,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              if (!_sent) ...[
                const Text('Reset your password',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 6),
                const Text("enter your email and we'll send a reset link",
                    style: TextStyle(color: AppColors.grey)),
                const SizedBox(height: 28),
                AppTextField(
                  label: 'email',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 28),
                GradientButton(text: 'send reset link', onTap: _sendLink),
              ] else ...[
                const Text('Check your email',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 6),
                Text('we sent a reset link to ${_emailCtrl.text.trim()}',
                    style: const TextStyle(color: AppColors.grey)),
                const SizedBox(height: 28),
                GradientButton(
                  text: 'back to login',
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
