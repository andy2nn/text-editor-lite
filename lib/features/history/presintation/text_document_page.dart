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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: _isEditing
            ? TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: const InputDecoration(
                  hintText: 'Название документа',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
              )
            : Text(document!.title),
        actions: _buildAppBarActions(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isEditing
            ? TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Содержание документа...',
                  border: InputBorder.none,
                ),
              )
            : SingleChildScrollView(
                child: Text(
                  document!.content.isEmpty
                      ? 'Документ пуст'
                      : document!.content,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    if (!canEdit) return [];

    return [
      if (_isEditing)
        IconButton(
          onPressed: _saveDocument,
          icon: const Icon(Icons.save),
          tooltip: 'Сохранить',
        )
      else
        IconButton(
          onPressed: () => setState(() => _isEditing = true),
          icon: const Icon(Icons.edit),
          tooltip: 'Редактировать',
        ),
      IconButton(
        onPressed: _isEditing ? _cancelEdit : _closeDocument,
        icon: const Icon(Icons.close),
        tooltip: _isEditing ? 'Отменить' : 'Закрыть',
      ),
    ];
  }

  Widget? _buildFloatingActionButton() {
    if (!_isEditing || !canEdit) return null;

    return FloatingActionButton(
      onPressed: _saveDocument,
      child: const Icon(Icons.save),
    );
  }

  void _saveDocument() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Название документа не может быть пустым'),
        ),
      );
      return;
    }

    final updatedDocument = TextDocumentEntity(
      id: document!.id,
      title: _titleController.text.trim(),
      content: _contentController.text,
      lastEdited: DateTime.now(),
    );

    document = updatedDocument;

    context.read<TextDocumentBloc>().add(
      UpdateTextDocument(document: updatedDocument),
    );

    setState(() => _isEditing = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Документ сохранен')));
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
