import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'bottom_nav.dart';
import 'folder_detail_screen.dart';

// Screen 9: Folders
class FoldersScreen extends StatefulWidget {
  const FoldersScreen({super.key});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  // Naya folder banana
  Future<void> _addFolder() async {
    final name = await askText(context, 'new folder');
    if (!mounted || name == null || name.isEmpty) return;
    if (DocStore.folders.contains(name)) {
      showMsg(context, 'Folder already exists');
      return;
    }
    setState(() => DocStore.addFolder(name));
  }

  // Folder kholna, wapas aane par counts refresh
  Future<void> _openFolder(String name) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FolderDetailScreen(folderName: name)),
    );
    if (!mounted) return;
    setState(() {});
  }

  // Long press par folder delete
  Future<void> _deleteFolder(String name) async {
    final ok = await confirmDialog(
      context,
      'delete folder',
      'Documents inside "$name" will move to Unsorted.',
      yes: 'delete',
    );
    if (ok && mounted) setState(() => DocStore.deleteFolder(name));
  }

  @override
  Widget build(BuildContext context) {
    final names = [DocStore.allFolders, ...DocStore.folders];

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
                      title: 'folders',
                      showBack: false,
                      trailing: IconButton(
                        icon: const Icon(Icons.create_new_folder_outlined,
                            color: AppColors.pink),
                        onPressed: _addFolder,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('long press a folder to delete it',
                        style: TextStyle(color: AppColors.grey, fontSize: 13)),
                    const SizedBox(height: 18),
                    Expanded(
                      child: ListView.builder(
                        itemCount: names.length,
                        itemBuilder: (context, i) {
                          final name = names[i];
                          final count = DocStore.docsIn(name).length;
                          final isAll = name == DocStore.allFolders;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: Icon(
                                isAll
                                    ? Icons.folder_copy_outlined
                                    : Icons.folder_outlined,
                                color: AppColors.pink,
                              ),
                              title: Text(name,
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(
                                '$count document${count == 1 ? '' : 's'}',
                                style: const TextStyle(
                                    color: AppColors.grey, fontSize: 12),
                              ),
                              trailing: const Icon(Icons.chevron_right,
                                  color: AppColors.grey),
                              onTap: () => _openFolder(name),
                              onLongPress:
                              isAll ? null : () => _deleteFolder(name),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppBottomBar(current: 1, onRefresh: () => setState(() {})),
          ],
        ),
      ),
    );
  }
}
