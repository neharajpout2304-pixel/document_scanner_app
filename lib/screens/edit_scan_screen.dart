import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'save_document_screen.dart';

// Screen 15: Enhance / edit scan
// Filter lagao, rotate karo, phir "next" se save screen par jao.
class EditScanScreen extends StatefulWidget {
  final int pages;
  const EditScanScreen({super.key, required this.pages});

  @override
  State<EditScanScreen> createState() => _EditScanScreenState();
}

class _EditScanScreenState extends State<EditScanScreen> {
  String _filter = 'Original';
  int _turns = 0; // rotate: har tap par 90 degree

  // Har filter ek ColorFilter matrix hai (4x5 numbers)
  static const Map<String, List<double>> _filters = {
    'Original': [
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0,
    ],
    'Magic': [
      1.3, 0, 0, 0, -38,
      0, 1.3, 0, 0, -38,
      0, 0, 1.3, 0, -38,
      0, 0, 0, 1, 0,
    ],
    'Gray': [
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0, 0, 0, 1, 0,
    ],
    'B&W': [
      0.85, 2.86, 0.29, 0, -382,
      0.85, 2.86, 0.29, 0, -382,
      0.85, 2.86, 0.29, 0, -382,
      0, 0, 0, 1, 0,
    ],
  };

  // Dummy scanned kagaz (rang hain taake filter ka asar nazar aaye)
  Widget _samplePaper() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFFF3E6C8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 26, color: const Color(0xFF2F6FDE)),
          const SizedBox(height: 18),
          for (int i = 0; i < 7; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FractionallySizedBox(
                widthFactor: i % 2 == 0 ? 1.0 : 0.75,
                child: Container(height: 10, color: const Color(0xFF8A8A8A)),
              ),
            ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Container(width: 70, height: 34, color: const Color(0xFFD64545)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(
                title: 'enhance',
                trailing: IconButton(
                  icon: const Icon(Icons.rotate_right, color: AppColors.pink),
                  onPressed: () => setState(() => _turns++),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 38),
                child: Text(
                  '${widget.pages} page${widget.pages == 1 ? '' : 's'} scanned',
                  style: const TextStyle(color: AppColors.grey),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Center(
                  child: RotatedBox(
                    quarterTurns: _turns,
                    child: AspectRatio(
                      aspectRatio: 0.72,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.matrix(_filters[_filter]!),
                          child: _samplePaper(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Filter chips
              Row(
                children: _filters.keys.map((name) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(name),
                      selected: _filter == name,
                      showCheckmark: false,
                      selectedColor: AppColors.pink,
                      backgroundColor: AppColors.field,
                      labelStyle: const TextStyle(color: Colors.white),
                      onSelected: (_) => setState(() => _filter = name),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              GradientButton(
                text: 'next',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SaveDocumentScreen(
                      pages: widget.pages,
                      filterName: _filter,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
