import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'document_viewer_screen.dart';

// Screen 10: Folder ke andar ke documents
class FolderDetailScreen extends StatefulWidget {
  final String folderName;
  const FolderDetailScreen({super.key, required this.folderName});

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  Future<void> _openDoc(ScannedDoc d) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DocumentViewerScreen(doc: d)),
    );
    if (!mounted) return;
    setState(() {}); // rename/move/delete ke baad list refresh
  }

  @override
  Widget build(BuildContext context) {
    final docs = DocStore.docsIn(widget.folderName);

    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(title: widget.folderName),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 38),
                child: Text(
                  '${docs.length} document${docs.length == 1 ? '' : 's'}',
                  style: const TextStyle(color: AppColors.grey),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: docs.isEmpty
                    ? const Center(
                  child: Text('This folder is empty',
                      style: TextStyle(color: AppColors.grey)),
                )
                    : ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i];
                    return DocTile(doc: d, onTap: () => _openDoc(d));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
