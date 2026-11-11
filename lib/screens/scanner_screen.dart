import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'edit_scan_screen.dart';

// Screen 8: Camera scanner
// Logic: capture dabao -> page count barhta hai, upar wale number (badge) par tap karo
// -> enhance screen (15) -> save screen (16) -> home.
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  int _pages = 0;
  bool _flashOn = false;

  void _capture() {
    setState(() => _pages++);
    showMsg(context, 'Page $_pages captured');
  }

  void _done() {
    if (_pages == 0) {
      showMsg(context, 'Capture at least one page first');
      return;
    }
    // Ab seedha save nahi, pehle enhance screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditScanScreen(pages: _pages)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050510),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: Icon(
                      _flashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    ),
                    onPressed: () => setState(() => _flashOn = !_flashOn),
                  ),
                  GestureDetector(
                    onTap: _done,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B2060),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('$_pages',
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text('align document within frame',
                style: TextStyle(color: AppColors.grey)),
            const SizedBox(height: 14),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 28),
                decoration: BoxDecoration(
                  color: const Color(0xFF150A1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.pink, width: 2),
                ),
                child: const Center(
                  child: Text('camera preview here',
                      style: TextStyle(color: Colors.white24)),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              _pages == 0
                  ? 'document detected - hold steady'
                  : 'tap the number on top to continue',
              style: const TextStyle(color: AppColors.grey),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.image_outlined,
                        color: Colors.white, size: 32),
                    onPressed: () => showMsg(context, 'Gallery coming soon'),
                  ),
                  GestureDetector(
                    onTap: _capture,
                    child: Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.pink, width: 4),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.buttonGradient,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.flip_camera_android_outlined,
                        color: Colors.white, size: 32),
                    onPressed: () => showMsg(context, 'Camera flipped'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
