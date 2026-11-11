import 'package:flutter/material.dart';
import 'app_theme.dart';

// setPin = naya PIN banana, verify = purana PIN check karna
enum LockMode { setPin, verify }

// Screen 17: App lock (4 digit PIN)
// Kamyab hone par Navigator.pop(context, true) se true wapas jata hai.
class AppLockScreen extends StatefulWidget {
  final LockMode mode;
  const AppLockScreen({super.key, required this.mode});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  String _entered = ''; // abhi jo digits dabaye
  String? _first; // set mode me pehli dafa dala hua PIN

  String get _title {
    if (widget.mode == LockMode.verify) return 'enter your PIN';
    return _first == null ? 'create a 4-digit PIN' : 'confirm your PIN';
  }

  void _onDigit(String d) {
    if (_entered.length >= 4) return;
    setState(() => _entered += d);
    if (_entered.length == 4) _check();
  }

  void _onBackspace() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  // 4 digits poore hone par check
  void _check() {
    if (widget.mode == LockMode.verify) {
      if (_entered == DocStore.pin) {
        Navigator.pop(context, true);
      } else {
        showMsg(context, 'Wrong PIN');
        setState(() => _entered = '');
      }
    } else {
      if (_first == null) {
        // pehli entry yaad rakho, dobara poocho
        setState(() {
          _first = _entered;
          _entered = '';
        });
      } else if (_first == _entered) {
        DocStore.pin = _entered;
        Navigator.pop(context, true);
      } else {
        showMsg(context, 'PINs do not match, try again');
        setState(() {
          _first = null;
          _entered = '';
        });
      }
    }
  }

  Widget _key(String label) {
    return GestureDetector(
      onTap: () => _onDigit(label),
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          color: AppColors.card,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(fontSize: 28, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _row(List<String> labels) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: labels.map(_key).toList(),
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
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.lock_outline, size: 56, color: AppColors.pink),
              const SizedBox(height: 20),
              Text(_title,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 24),
              // 4 dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final filled = i < _entered.length;
                  return Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? AppColors.pink : Colors.transparent,
                      border: Border.all(color: AppColors.pink, width: 2),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 36),
              _row(['1', '2', '3']),
              _row(['4', '5', '6']),
              _row(['7', '8', '9']),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 72, height: 72),
                  _key('0'),
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: IconButton(
                      icon: const Icon(Icons.backspace_outlined,
                          color: AppColors.grey),
                      onPressed: _onBackspace,
                    ),
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
