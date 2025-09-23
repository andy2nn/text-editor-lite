import 'package:flutter/material.dart';

class DocumentDialog extends StatefulWidget {
  final Function(String) onSave;

  const DocumentDialog({super.key, required this.onSave});

  @override
  State<DocumentDialog> createState() => _DocumentDialogState();
}

class _DocumentDialogState extends State<DocumentDialog> {
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Создать документ'),
      content: TextField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'Название документа',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.trim().isNotEmpty) {
              widget.onSave(_titleController.text.trim());
            }
          },
          child: const Text('Создать'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
