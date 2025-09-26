import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_cloud_crm_web/core/untils/snack_bar_helper.dart';
import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_bloc.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_event.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_state.dart';
import 'package:training_cloud_crm_web/widgets/custom_app_bar.dart';
import 'package:training_cloud_crm_web/widgets/custom_floating_action_button.dart';
import 'package:training_cloud_crm_web/widgets/custom_icon_button.dart';

class TextDocumentPage extends StatefulWidget {
  const TextDocumentPage({super.key});

  @override
  State<TextDocumentPage> createState() => _TextDocumentPageState();
}

class _TextDocumentPageState extends State<TextDocumentPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late final TextDocumentEntity document;
  bool _isEditing = false;

  bool _canEdit = false;

  @override
  void initState() {
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _loadArguments();
    super.didChangeDependencies();
  }

  void _loadArguments() {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      document = arguments['document'] as TextDocumentEntity;
      _canEdit = arguments['canEdit'] as bool;

      _titleController.text = document.title;
      _contentController.text = document.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TextDocumentBloc, TextDocumentState>(
      listener: (context, state) {
        switch (state) {
          case TextDocumentEditingSuccess():
            SnackBarHelper.showSuccess(context, 'Документ сохранен');
            _isEditing = false;
            Navigator.pop(context);
          case TextDocumentError():
            SnackBarHelper.showError(context, state.errorMessage);
          case TextDocumentEditing():
            _isEditing = true;

          case TextDocumentEditingCancel():
            _isEditing = false;

          default:
            break;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: CustomAppBar(
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
                    document.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
            actions: [
              _canEdit
                  ? Row(
                      children: [
                        _isEditing
                            ? CustomIconButton(
                                onPressed: () => _saveDocument(context),
                                iconData: Icons.save_rounded,
                                tooltip: 'Сохранить',
                              )
                            : CustomIconButton(
                                onPressed: () => context
                                    .read<TextDocumentBloc>()
                                    .add(StartTextDocumentEditing()),
                                iconData: Icons.edit_rounded,
                                tooltip: 'Редактировать',
                              ),
                        CustomIconButton(
                          onPressed: () => _isEditing
                              ? context.read<TextDocumentBloc>().add(
                                  CancelTextDocumentEditing(),
                                )
                              : Navigator.pop(context),
                          iconData: Icons.close_rounded,
                          tooltip: _isEditing ? 'Отменить' : 'Закрыть',
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ],
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
                        document.content.isEmpty
                            ? 'Документ пуст'
                            : document.content,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.5,
                        ),
                      ),
                    ),
            ),
          ),
          floatingActionButton: !_isEditing
              ? null
              : CustomFloatingActionButton(
                  onPressed: () => _saveDocument(context),

                  child: const Icon(Icons.save_rounded, size: 28),
                ),
        );
      },
    );
  }

  void _saveDocument(BuildContext context) {
    if (_titleController.text.trim().isEmpty) {
      SnackBarHelper.showError(
        context,
        'Название документа не может быть пустым',
      );
      return;
    }

    context.read<TextDocumentBloc>().add(
      UpdateTextDocument(
        document: document.copyWith(
          title: _titleController.text.trim(),
          content: _contentController.text,
          lastEdited: DateTime.now(),
        ),
      ),
    );
  }
}
