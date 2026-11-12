import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'home_screen.dart';
import 'folders_screen.dart';
import 'tags_screen.dart';
import 'settings_screen.dart';
import 'scanner_screen.dart';

class AppBottomBar extends StatelessWidget {
  final int current;
  final VoidCallback? onRefresh;

  const AppBottomBar({super.key, required this.current, this.onRefresh});

  void _go(BuildContext context, int index) {
    if (index == current) return;
    Widget page;
    switch (index) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const FoldersScreen();
        break;
      case 3:
        page = const TagsScreen();
        break;
      default:
        page = const SettingsScreen();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<void> _openScanner(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScannerScreen()),
    );
    if (context.mounted) onRefresh?.call();
  }

  Widget _item(BuildContext context, IconData icon, int index) {
    return IconButton(
      icon: Icon(icon,
          color: current == index ? AppColors.pink : AppColors.grey),
      onPressed: () => _go(context, index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      color: const Color(0xFF0D0716),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _item(context, Icons.home_outlined, 0),
          _item(context, Icons.folder_outlined, 1),
          GestureDetector(
            onTap: () => _openScanner(context),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.buttonGradient,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.pink.withOpacity(0.5), blurRadius: 16)
                ],
              ),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            ),
          ),
          _item(context, Icons.local_offer_outlined, 3),
          _item(context, Icons.settings_outlined, 4),
        ],
      ),
    );
  }
}
