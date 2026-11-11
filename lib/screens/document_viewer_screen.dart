import 'package:flutter/material.dart';
import 'app_theme.dart';

// Screen 14: Document viewer
// Pages swipe karke dekho, rename / move / tag / delete karo.
class DocumentViewerScreen extends StatefulWidget {
  final ScannedDoc doc;
  const DocumentViewerScreen({super.key, required this.doc});

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  final PageController _controller = PageController();
  int _current = 0;

  ScannedDoc get doc => widget.doc;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Naam badalna (.pdf khud lag jata hai)
  Future<void> _rename() async {
    final base = doc.name.endsWith('.pdf')
        ? doc.name.substring(0, doc.name.length - 4)
        : doc.name;
    final newName = await askText(context, 'rename document', initial: base);
    if (!mounted || newName == null || newName.isEmpty) return;
    setState(() => doc.name = '$newName.pdf');
  }

  // Dusre folder me bhejna
  Future<void> _move() async {
    final folder = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: AppColors.card,
        title:
        const Text('move to folder', style: TextStyle(color: Colors.white)),
        children: [DocStore.unsorted, ...DocStore.folders]
            .map((f) => SimpleDialogOption(
          onPressed: () => Navigator.pop(ctx, f),
          child: Text(f,
              style: TextStyle(
                  color: f == doc.folder
                      ? AppColors.pink
                      : Colors.white)),
        ))
            .toList(),
      ),
    );
    if (!mounted || folder == null) return;
    setState(() => doc.folder = folder);
    showMsg(context, 'Moved to $folder');
  }

  // Tags lagana / hatana (checkbox list)
  Future<void> _editTags() async {
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text('tags', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: DocStore.tags
                  .map((t) => CheckboxListTile(
                value: doc.tags.contains(t),
                activeColor: AppColors.pink,
                title: Text(t,
                    style: const TextStyle(color: Colors.white)),
                onChanged: (v) {
                  setLocal(() {
                    if (v == true) {
                      if (!doc.tags.contains(t)) doc.tags.add(t);
                    } else {
                      doc.tags.remove(t);
                    }
                  });
                },
              ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('done',
                  style: TextStyle(color: AppColors.pink)),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    setState(() {});
  }

  // Delete = trash me bhejna (settings > trash se wapas aa sakta hai)
  Future<void> _delete() async {
    final ok = await confirmDialog(
        context, 'delete document', 'Move "${doc.name}" to trash?',
        yes: 'delete');
    if (!ok || !mounted) return;
    DocStore.moveToTrash(doc);
    showMsg(context, 'Moved to trash');
    Navigator.pop(context);
  }

  // Ek page ka dummy "kagaz"
  Widget _paper(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EEE6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 22, width: 140, color: const Color(0xFF9B8FB0)),
          const SizedBox(height: 22),
          for (int i = 0; i < 8; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FractionallySizedBox(
                widthFactor: i % 3 == 0 ? 1.0 : (i % 3 == 1 ? 0.85 : 0.6),
                child: Container(height: 10, color: const Color(0xFFCFC7BF)),
              ),
            ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Text('page ${index + 1}',
                style: const TextStyle(color: Colors.black45)),
          ),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String label, VoidCallback onTap,
      {Color color = Colors.white}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
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
                title: doc.name,
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.pink),
                  onPressed: _rename,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: doc.pages,
                  onPageChanged: (i) => setState(() => _current = i),
                  itemBuilder: (context, i) => _paper(i),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text('${_current + 1} / ${doc.pages}',
                    style: const TextStyle(color: AppColors.grey)),
              ),
              const SizedBox(height: 10),
              Text('folder: ${doc.folder}',
                  style: const TextStyle(color: AppColors.grey)),
              const SizedBox(height: 6),
              Text(
                doc.tags.isEmpty
                    ? 'no tags'
                    : doc.tags.map((t) => '#$t').join('  '),
                style: const TextStyle(color: AppColors.pink),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _action(Icons.share_outlined, 'share',
                          () => showMsg(context, 'Share coming soon')),
                  _action(Icons.drive_file_move_outline, 'move', _move),
                  _action(Icons.local_offer_outlined, 'tags', _editTags),
                  _action(Icons.delete_outline, 'delete', _delete,
                      color: AppColors.danger),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
