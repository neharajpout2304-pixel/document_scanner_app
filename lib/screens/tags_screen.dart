import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'bottom_nav.dart';
import 'document_viewer_screen.dart';

// Screen 11: Tags
class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  String? _selected; // abhi kaun sa tag select hai (null = koi nahi)

  Future<void> _addTag() async {
    final name = await askText(context, 'new tag');
    if (!mounted || name == null || name.isEmpty) return;
    setState(() => DocStore.addTag(name.toLowerCase()));
  }

  Future<void> _openDoc(ScannedDoc d) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DocumentViewerScreen(doc: d)),
    );
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Select kiye hue tag wale documents
    final docs = _selected == null ? <ScannedDoc>[] : DocStore.docsWithTag(_selected!);

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
                    ScreenHeader(
                      title: 'tags',
                      showBack: false,
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle_outline,
                            color: AppColors.pink),
                        onPressed: _addTag,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: DocStore.tags.map((t) {
                        final count = DocStore.docsWithTag(t).length;
                        return ChoiceChip(
                          label: Text('#$t ($count)'),
                          selected: _selected == t,
                          showCheckmark: false,
                          selectedColor: AppColors.pink,
                          backgroundColor: AppColors.field,
                          labelStyle: const TextStyle(color: Colors.white),
                          onSelected: (_) => setState(
                                  () => _selected = _selected == t ? null : t),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),
                    Expanded(
                      child: _selected == null
                          ? const Center(
                        child: Text('select a tag to see its documents',
                            style: TextStyle(color: AppColors.grey)),
                      )
                          : docs.isEmpty
                          ? const Center(
                        child: Text('No documents with this tag',
                            style: TextStyle(color: AppColors.grey)),
                      )
                          : ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, i) {
                          final d = docs[i];
                          return DocTile(
                              doc: d, onTap: () => _openDoc(d));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppBottomBar(current: 3, onRefresh: () => setState(() {})),
          ],
        ),
      ),
    );
  }
}
