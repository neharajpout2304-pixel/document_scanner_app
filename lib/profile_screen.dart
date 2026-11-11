import 'package:flutter/material.dart';
import 'app_theme.dart';

// Screen 13: Profile (naam / email badalna)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers me pehle se purani values bhar di
  final _nameCtrl = TextEditingController(text: DocStore.userName);
  final _emailCtrl = TextEditingController(text: DocStore.userEmail);

  void _save() {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();

    if (name.isEmpty || email.isEmpty) {
      showMsg(context, 'Please fill all fields');
      return;
    }
    if (!email.contains('@')) {
      showMsg(context, 'Enter a valid email');
      return;
    }

    DocStore.userName = name;
    DocStore.userEmail = email;
    showMsg(context, 'Profile updated');
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initial = DocStore.userName.isEmpty
        ? '?'
        : DocStore.userName[0].toUpperCase();

    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenHeader(title: 'profile'),
              const SizedBox(height: 28),
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.buttonGradient,
                  ),
                  child: Center(
                    child: Text(initial,
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AppTextField(label: 'full name', controller: _nameCtrl),
              const SizedBox(height: 22),
              AppTextField(
                label: 'email',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 28),
              GradientButton(text: 'save changes', onTap: _save),
            ],
          ),
        ),
      ),
    );
  }
}
