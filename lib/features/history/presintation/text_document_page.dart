import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_bloc.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_event.dart';

class TextDocumentPage extends StatefulWidget {
  const TextDocumentPage({super.key});

  @override
  State<TextDocumentPage> createState() => _TextDocumentPageState();
}

class _TextDocumentPageState extends State<TextDocumentPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  TextDocumentEntity? document;
  bool canEdit = false;
  bool _isEditing = false;
  bool _isArgumentsLoaded = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isArgumentsLoaded) {
      _loadArguments();
    }
  }

  void _loadArguments() {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      document = arguments['document'] as TextDocumentEntity;
      canEdit = arguments['canEdit'] as bool;

      _titleController.text = document!.title;
      _contentController.text = document!.content;
      _isArgumentsLoaded = true;

      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isArgumentsLoaded || document == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: _isEditing
            ? TextField(
                controller: _titleController,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Введите название...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              )
            : Text(
                document!.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: _buildAppBarActions(),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _isEditing
              ? TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Начните вводить текст...',
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                  ),
                )
              : SingleChildScrollView(
                  child: Text(
                    document!.content.isEmpty
                        ? 'Документ пуст'
                        : document!.content,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (!canEdit) return [];

    return [
      if (_isEditing)
        IconButton(
          onPressed: _saveDocument,
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.save_rounded, size: 22),
          ),
          tooltip: 'Сохранить',
        )
      else
        IconButton(
          onPressed: () => setState(() => _isEditing = true),
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.edit_rounded, size: 22),
          ),
          tooltip: 'Редактировать',
        ),
      IconButton(
        onPressed: _isEditing ? _cancelEdit : _closeDocument,
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.close_rounded, size: 22),
        ),
        tooltip: _isEditing ? 'Отменить' : 'Закрыть',
      ),
    ];
  }

  Widget? _buildFloatingActionButton() {
    if (!_isEditing || !canEdit) return null;

    return FloatingActionButton(
      onPressed: _saveDocument,
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.save_rounded, size: 28),
    );
  }

  void _saveDocument() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Название документа не может быть пустым'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final updatedDocument = document!.copyWith(
      title: _titleController.text.trim(),
      content: _contentController.text,
      lastEdited: DateTime.now(),
    );

    document = updatedDocument;

    context.read<TextDocumentBloc>().add(
      UpdateTextDocument(document: updatedDocument),
    );

    setState(() => _isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Документ сохранен'),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _cancelEdit() {
    setState(() {
      _titleController.text = document!.title;
      _contentController.text = document!.content;
      _isEditing = false;
    });
  }

  void _closeDocument() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
