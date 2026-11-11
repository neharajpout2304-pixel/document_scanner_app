import 'package:flutter/material.dart';
import 'app_theme.dart';

// Screen 20: About & Help
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Question/answer ki ek row (tap karke khulti hai)
  Widget _faq(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        iconColor: AppColors.pink,
        collapsedIconColor: AppColors.grey,
        shape: const Border(), // upar neeche ki lakeerein hata di
        collapsedShape: const Border(),
        title: Text(question, style: const TextStyle(color: Colors.white)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(answer, style: const TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const ScreenHeader(title: 'about & help'),
            const SizedBox(height: 28),
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Icon(Icons.description_outlined,
                    size: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text('DocScan',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            const Center(
              child: Text('version 1.0.0',
                  style: TextStyle(color: AppColors.grey)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Scan. Enhance. Save. A simple document scanner that keeps your papers organized and private.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey, height: 1.5),
            ),
            const SizedBox(height: 28),
            const Text('help',
                style: TextStyle(color: AppColors.grey, fontSize: 15)),
            const SizedBox(height: 10),
            _faq('How do I scan a document?',
                'Tap the camera button, capture your pages, then tap the number on top to enhance and save.'),
            _faq('Where do deleted documents go?',
                'To Settings > Trash. You can restore them or delete them forever from there.'),
            _faq('How do I lock the app?',
                'Turn on App lock in Settings and choose a 4-digit PIN.'),
            const SizedBox(height: 14),
            GradientButton(
              text: 'contact support',
              onTap: () => showMsg(context, 'Support coming soon'),
            ),
          ],
        ),
      ),
    );
  }
}
