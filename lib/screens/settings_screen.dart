import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'bottom_nav.dart';
import 'profile_screen.dart';
import 'app_lock_screen.dart';
import 'trash_screen.dart';
import 'about_screen.dart';
import 'login_screen.dart';

// Screen 12: Settings
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // App lock on/off. On karne par PIN set, off karne par PIN verify
  Future<void> _toggleLock(bool turnOn) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AppLockScreen(
          mode: turnOn ? LockMode.setPin : LockMode.verify,
        ),
      ),
    );
    if (!mounted || ok != true) return;
    setState(() {
      DocStore.appLockOn = turnOn;
      if (!turnOn) DocStore.pin = null;
    });
  }

  // Koi screen kholo, wapas aane par refresh
  Future<void> _open(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _logout() async {
    final ok = await confirmDialog(
        context, 'log out', 'Do you want to log out?', yes: 'log out');
    if (!ok || !mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  // Ek settings row banane ka helper
  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color color = Colors.white,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.pink),
        title: Text(title, style: TextStyle(color: color)),
        subtitle: subtitle == null
            ? null
            : Text(subtitle,
            style: const TextStyle(color: AppColors.grey, fontSize: 12)),
        trailing: trailing ??
            (onTap == null
                ? null
                : const Icon(Icons.chevron_right, color: AppColors.grey)),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initial = DocStore.userName.isEmpty
        ? '?'
        : DocStore.userName[0].toUpperCase();

    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const ScreenHeader(title: 'settings', showBack: false),
                  const SizedBox(height: 20),
                  // Profile card
                  GestureDetector(
                    onTap: () => _open(const ProfileScreen()),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.buttonGradient,
                            ),
                            child: Center(
                              child: Text(initial,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(DocStore.userName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Text(DocStore.userEmail,
                                    style: const TextStyle(
                                        color: AppColors.grey, fontSize: 13)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: AppColors.grey),
                        ],
                      ),
                    ),
                  ),
                  _tile(
                    icon: Icons.lock_outline,
                    title: 'app lock',
                    subtitle: DocStore.appLockOn ? 'PIN is on' : 'PIN is off',
                    trailing: Switch(
                      value: DocStore.appLockOn,
                      activeColor: AppColors.pink,
                      onChanged: _toggleLock,
                    ),
                  ),
                  _tile(
                    icon: Icons.delete_outline,
                    title: 'trash',
                    subtitle: '${DocStore.trash.length} deleted',
                    onTap: () => _open(const TrashScreen()),
                  ),
                  _tile(
                    icon: Icons.info_outline,
                    title: 'about & help',
                    onTap: () => _open(const AboutScreen()),
                  ),
                  _tile(
                    icon: Icons.logout,
                    title: 'log out',
                    color: AppColors.danger,
                    onTap: _logout,
                  ),
                ],
              ),
            ),
            AppBottomBar(current: 4, onRefresh: () => setState(() {})),
          ],
        ),
      ),
    );
  }
}
