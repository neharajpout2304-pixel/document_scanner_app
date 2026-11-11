import 'package:flutter/material.dart';
import 'app_theme.dart';

// Screen 16: Save document (naam, folder, tags choose karo)
class SaveDocumentScreen extends StatefulWidget {
  final int pages;
  final String filterName;
  const SaveDocumentScreen(
      {super.key, required this.pages, required this.filterName});

  @override
  State<SaveDocumentScreen> createState() => _SaveDocumentScreenState();
}

class _SaveDocumentScreenState extends State<SaveDocumentScreen> {
  final _nameCtrl =
  TextEditingController(text: 'scan ${DocStore.totalScans + 1}');
  String _folder = DocStore.unsorted;
  final List<String> _selectedTags = [];

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      showMsg(context, 'Enter a document name');
      return;
    }

    DocStore.addDoc(name, widget.pages, _folder, _selectedTags);
    showMsg(context, 'Document saved');

    // Home tak wapas (scanner, enhance, save teeno band)
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenHeader(title: 'save document'),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 38),
                child: Text(
                  '${widget.pages} page${widget.pages == 1 ? '' : 's'} - filter: ${widget.filterName}',
                  style: const TextStyle(color: AppColors.grey),
                ),
              ),
              const SizedBox(height: 28),
              AppTextField(label: 'document name', controller: _nameCtrl),
              const SizedBox(height: 22),
              const Text('folder',
                  style: TextStyle(color: AppColors.grey, fontSize: 14)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _folder,
                dropdownColor: AppColors.card,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.field,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: [DocStore.unsorted, ...DocStore.folders]
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (v) => setState(() => _folder = v!),
              ),
              const SizedBox(height: 22),
              const Text('tags',
                  style: TextStyle(color: AppColors.grey, fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: DocStore.tags.map((t) {
                  return FilterChip(
                    label: Text('#$t'),
                    selected: _selectedTags.contains(t),
                    showCheckmark: false,
                    selectedColor: AppColors.pink,
                    backgroundColor: AppColors.field,
                    labelStyle: const TextStyle(color: Colors.white),
                    onSelected: (isOn) {
                      setState(() {
                        if (isOn) {
                          _selectedTags.add(t);
                        } else {
                          _selectedTags.remove(t);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              GradientButton(text: 'save document', onTap: _save),
            ],
          ),
        ),
      ),
    );
  }
}
