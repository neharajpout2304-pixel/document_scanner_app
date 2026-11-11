import 'package:flutter/material.dart';

// ---------- Colors ----------
class AppColors {
  static const bgTop = Color(0xFF1C0F33);
  static const bgBottom = Color(0xFF110A1F);
  static const field = Color(0xFF381A5A);
  static const card = Color(0xFF2E1740);
  static const pink = Color(0xFFFF2DA0);
  static const grey = Color(0xFFA79BB8);
  static const danger = Color(0xFFFF5470);
  static const buttonGradient = LinearGradient(
    colors: [Color(0xFFC62BDB), Color(0xFF9A0058)],
  );
}

// ---------- Data (memory me, app band hone par reset ho jata hai) ----------

// Ek document. Ab isme folder aur tags bhi hain.
class ScannedDoc {
  String name;
  int pages;
  String date;
  String folder;
  List<String> tags;

  ScannedDoc({
    required this.name,
    required this.pages,
    this.date = 'today',
    this.folder = 'Unsorted',
    List<String>? tags,
  }) : tags = tags ?? [];

  // Home/list me dikhne wali line, jaise "today - 2 pages"
  String get info => '$date - $pages page${pages == 1 ? '' : 's'}';
}

// Poori app ka chhota sa database (static = har screen ek hi data dekhti hai)
class DocStore {
  static const String allFolders = 'All documents';
  static const String unsorted = 'Unsorted';

  static int totalScans = 128;
  static int storageMb = 64;

  // User ka data (signup/login/profile se set hota hai)
  static String userName = 'Student';
  static String userEmail = 'student@email.com';

  // App lock
  static bool appLockOn = false;
  static String? pin;

  static final List<String> folders = ['Personal', 'University', 'Bills'];
  static final List<String> tags = ['important', 'id', 'receipt'];

  static final List<ScannedDoc> docs = [
    ScannedDoc(
        name: 'electricity bill.pdf',
        pages: 2,
        folder: 'Bills',
        tags: ['receipt']),
    ScannedDoc(
        name: 'cnic front.pdf',
        pages: 1,
        date: 'yesterday',
        folder: 'Personal',
        tags: ['id', 'important']),
  ];

  static final List<ScannedDoc> trash = [];

  // Naya document list ke start me add
  static void addDoc(
      String name, int pages, String folder, List<String> docTags) {
    totalScans += 1;
    storageMb += 1;
    docs.insert(
      0,
      ScannedDoc(
        name: name.endsWith('.pdf') ? name : '$name.pdf',
        pages: pages,
        folder: folder,
        tags: List<String>.from(docTags),
      ),
    );
  }

  static List<ScannedDoc> docsIn(String folder) {
    if (folder == allFolders) return docs;
    return docs.where((d) => d.folder == folder).toList();
  }

  static List<ScannedDoc> docsWithTag(String tag) {
    return docs.where((d) => d.tags.contains(tag)).toList();
  }

  static void addFolder(String name) {
    if (name.isNotEmpty && !folders.contains(name)) folders.add(name);
  }

  // Folder delete ho to uske documents "Unsorted" me chale jate hain
  static void deleteFolder(String name) {
    folders.remove(name);
    for (final d in docs) {
      if (d.folder == name) d.folder = unsorted;
    }
  }

  static void addTag(String name) {
    if (name.isNotEmpty && !tags.contains(name)) tags.add(name);
  }

  static void moveToTrash(ScannedDoc d) {
    docs.remove(d);
    trash.insert(0, d);
  }

  static void restore(ScannedDoc d) {
    trash.remove(d);
    if (d.folder != unsorted && !folders.contains(d.folder)) {
      d.folder = unsorted;
    }
    docs.insert(0, d);
  }

  static void deleteForever(ScannedDoc d) {
    trash.remove(d);
  }

  static void emptyTrash() {
    trash.clear();
  }
}

// ---------- Reusable widgets ----------

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bgTop, AppColors.bgBottom],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const GradientButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.grey, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.field,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

// Screen ke upar: back arrow + title + (optional) right side widget
class ScreenHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final bool showBack;

  const ScreenHeader({
    super.key,
    required this.title,
    this.trailing,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack)
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        if (showBack) const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

// Document ki ek row (home, folder, tags, trash sab me use hoti hai)
class DocTile extends StatelessWidget {
  final ScannedDoc doc;
  final VoidCallback onTap;
  final Widget? trailing;

  const DocTile({
    super.key,
    required this.doc,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading:
        const Icon(Icons.picture_as_pdf_outlined, color: AppColors.pink),
        title: Text(doc.name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(doc.info,
            style: const TextStyle(color: AppColors.grey, fontSize: 12)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

// ---------- Helper functions ----------

void showMsg(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
  );
}

// Yes/No dialog. true wapas deta hai agar user "yes" dabaye
Future<bool> confirmDialog(BuildContext context, String title, String text,
    {String yes = 'yes'}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.card,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      content: Text(text, style: const TextStyle(color: AppColors.grey)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(yes, style: const TextStyle(color: AppColors.pink)),
        ),
      ],
    ),
  );
  return result ?? false;
}

// Text poochne wala dialog (new folder, new tag, rename ke liye)
Future<String?> askText(BuildContext context, String title,
    {String initial = ''}) async {
  final ctrl = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.card,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.field,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
          child: const Text('ok', style: TextStyle(color: AppColors.pink)),
        ),
      ],
    ),
  );
}
