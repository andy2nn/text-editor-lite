import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_bloc.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_event.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_state.dart';
import 'package:training_cloud_crm_web/widgets/document_dialog_widget.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TextDocumentBloc, TextDocumentState>(
      listener: (context, state) {
        if (state is TextDocumentError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
        if (state is TextDocumentAdded) {
          _navigateToDocument(context, state.document);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Документы'),
            actions: [
              IconButton(
                onPressed: () =>
                    context.read<TextDocumentBloc>().add(SyncTextDocuments()),
                icon: const Icon(Icons.sync),
                tooltip: 'Синхронизировать',
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                icon: Icon(Icons.settings),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: _buildContent(state),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddDocumentDialog(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildContent(TextDocumentState state) {
    if (state is TextDocumentLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TextDocumentLoaded) {
      return state.documents.isEmpty
          ? const Center(child: Text('Нет документов'))
          : ListView.builder(
              itemCount: state.documents.length,
              itemBuilder: (context, index) {
                final document = state.documents[index];
                return Card(
                  child: ListTile(
                    title: Text(document.title),
                    subtitle: Text(
                      'Изменен: ${_formatDate(document.lastEdited)}',
                    ),
                    trailing: IconButton(
                      onPressed: () => context.read<TextDocumentBloc>().add(
                        DeleteTextDocument(id: document.id),
                      ),
                      icon: const Icon(Icons.delete),
                      tooltip: 'Удалить',
                    ),
                    onTap: () => _navigateToDocument(context, document),
                  ),
                );
              },
            );
    } else if (state is TextDocumentError) {
      return Center(child: Text('Ошибка: ${state.errorMessage}'));
    } else {
      return const Center(child: Text('Загрузите документы'));
    }
  }

  void _showAddDocumentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DocumentDialog(
        onSave: (title) {
          context.read<TextDocumentBloc>().add(AddTextDocument(title: title));
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _navigateToDocument(BuildContext context, document) {
    bool isMobile = true;
    if (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux) {
      isMobile = false;
    }

    Navigator.pushNamed(
      context,
      "/textDocumentPage",
      arguments: {'document': document, 'canEdit': !isMobile},
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
