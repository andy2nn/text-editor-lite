import 'package:flutter/material.dart';
import 'package:training_cloud_crm_web/widgets/custom_textfield.dart';

class DocumentDialog extends StatefulWidget {
  final Function(String, String?) onSave;

  const DocumentDialog({super.key, required this.onSave});

  @override
  State<DocumentDialog> createState() => _DocumentDialogState();
}

class _DocumentDialogState extends State<DocumentDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _documentPasswordController;
  bool _toggle = false;

  @override
  void initState() {
    _titleController = TextEditingController();
    _documentPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _documentPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Создать документ'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          CustomTextField(
            controller: _titleController,
            labelText: 'Название документа',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Зашифровать",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Switch(
                onChanged: (value) => setState(() {
                  _toggle = value;
                }),
                value: _toggle,
              ),
            ],
          ),
          _toggle
              ? CustomTextField(
                  controller: _documentPasswordController,
                  labelText: 'Пароль для документа',
                )
              : SizedBox.shrink(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.trim().isNotEmpty) {
              widget.onSave(
                _titleController.text.trim(),
                _documentPasswordController.text.trim().isEmpty
                    ? null
                    : _documentPasswordController.text.trim(),
              );
            }
          },
          child: const Text('Создать'),
        ),
      ],
    );
  }
}
