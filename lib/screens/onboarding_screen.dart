import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

// Screens 2, 3, 4: Onboarding (scan anything / auto enhance / organized & secure)
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  // Teeno pages ka data
  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.gps_fixed,
      'title': 'scan anything',
      'text': 'Point your camera at any document for an instant, crisp digital copy.',
    },
    {
      'icon': Icons.auto_fix_high,
      'title': 'auto enhance',
      'text': 'Shadows removed, edges sharpened, text made crystal clear automatically.',
    },
    {
      'icon': Icons.security,
      'title': 'organized & secure',
      'text': 'Folders, tags and app-lock keep every document sorted and private.',
    },
  ];

  bool get _isLast => _page == _pages.length - 1;

  void _next() {
    if (_isLast) {
      // "get started" -> create account
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignupScreen()),
      );
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    // "Skip" -> login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Skip button (last page par hide)
              SizedBox(
                height: 40,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _isLast
                      ? null
                      : TextButton(
                    onPressed: _skip,
                    child: const Text('Skip',
                        style: TextStyle(color: AppColors.grey)),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) {
                    final p = _pages[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 240,
                          decoration: BoxDecoration(
                            color: AppColors.field,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Icon(p['icon'],
                              size: 110, color: AppColors.pink),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          p['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          p['text'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15, color: AppColors.grey, height: 1.5),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 32 : 10,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? AppColors.pink : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),
              GradientButton(
                text: _isLast ? 'get started' : 'next',
                onTap: _next,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
