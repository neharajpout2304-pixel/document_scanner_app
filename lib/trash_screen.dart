import 'package:flutter/material.dart';
import 'app_theme.dart';

// Screen 19: Trash (delete kiye hue documents)
class TrashScreen extends StatefulWidget {
  const TrashScreen({super.key});

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  Future<void> _emptyTrash() async {
    if (DocStore.trash.isEmpty) {
      showMsg(context, 'Trash is already empty');
      return;
    }
    final ok = await confirmDialog(
      context,
      'empty trash',
      'All documents in trash will be deleted forever.',
      yes: 'delete',
    );
    if (ok && mounted) setState(() => DocStore.emptyTrash());
  }

  Future<void> _deleteForever(ScannedDoc d) async {
    final ok = await confirmDialog(
      context,
      'delete forever',
      '"${d.name}" cannot be recovered.',
      yes: 'delete',
    );
    if (ok && mounted) setState(() => DocStore.deleteForever(d));
  }

  @override
  Widget build(BuildContext context) {
    final items = DocStore.trash;

    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(
                title: 'trash',
                trailing: IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined,
                      color: AppColors.pink),
                  onPressed: _emptyTrash,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: items.isEmpty
                    ? const Center(
                  child: Text('trash is empty',
                      style: TextStyle(color: AppColors.grey)),
                )
                    : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final d = items[i];
                    return DocTile(
                      doc: d,
                      onTap: () => showMsg(
                          context, 'Restore it to open this document'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.restore,
                                color: AppColors.pink),
                            onPressed: () {
                              setState(() => DocStore.restore(d));
                              showMsg(context, 'Document restored');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever,
                                color: AppColors.danger),
                            onPressed: () => _deleteForever(d),
                          ),
                        ],
                      ),
                    );
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
