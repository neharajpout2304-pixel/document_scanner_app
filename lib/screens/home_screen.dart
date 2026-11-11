import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'bottom_nav.dart';
import 'document_viewer_screen.dart';

// Screen 7: Home (my document)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';

  // Document kholo, wapas aane par list refresh (rename/delete nazar aaye)
  Future<void> _openDoc(ScannedDoc d) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DocumentViewerScreen(doc: d)),
    );
    if (!mounted) return;
    setState(() {});
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'good morning';
    if (h < 17) return 'good afternoon';
    return 'good evening';
  }

  Widget _statCard(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: AppColors.grey, fontSize: 13)),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = DocStore.docs
        .where((d) => d.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_greeting(),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 16)),
                    const Text('my document',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 18),
                    TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'search document',
                        hintStyle: const TextStyle(color: AppColors.grey),
                        prefixIcon:
                        const Icon(Icons.search, color: AppColors.grey),
                        filled: true,
                        fillColor: AppColors.field,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        _statCard('total scans', '${DocStore.totalScans}'),
                        _statCard('storage used', '${DocStore.storageMb} mb'),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text('recent',
                        style: TextStyle(color: AppColors.grey, fontSize: 15)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: results.isEmpty
                          ? const Center(
                          child: Text('No documents found',
                              style: TextStyle(color: AppColors.grey)))
                          : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, i) {
                          final d = results[i];
                          return DocTile(doc: d, onTap: () => _openDoc(d));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppBottomBar(current: 0, onRefresh: () => setState(() {})),
          ],
        ),
      ),
    );
  }
}
