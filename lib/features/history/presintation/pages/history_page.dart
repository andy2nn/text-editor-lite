import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:training_cloud_crm_web/core/untils/app_navigator.dart';
import 'package:training_cloud_crm_web/core/untils/snack_bar_helper.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_bloc.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_event.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_state.dart';
import 'package:training_cloud_crm_web/widgets/custom_app_bar.dart';
import 'package:training_cloud_crm_web/widgets/custom_floating_action_button.dart';
import 'package:training_cloud_crm_web/widgets/custom_icon_button.dart';
import 'package:training_cloud_crm_web/widgets/document_card.dart';
import 'package:training_cloud_crm_web/widgets/document_dialog_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    context.read<TextDocumentBloc>().add(LoadTextDocuments());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TextDocumentBloc, TextDocumentState>(
      listener: (context, state) {
        switch (state) {
          case TextDocumentError():
            SnackBarHelper.showError(context, state.errorMessage);
          case TextDocumentAdded():
            _navigateToDocument(context, state.document);
        }
      },
      builder: (context, state) {
        final bloc = context.read<TextDocumentBloc>();
        return Scaffold(
          appBar: CustomAppBar(
            title: const Text('Документы'),
            actions: [
              CustomIconButton(
                onPressed: () =>
                    context.read<TextDocumentBloc>().add(SyncTextDocuments()),
                iconData: Icons.sync,
                tooltip: 'Синхронизировать',
              ),
              CustomIconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppNavigator.settingsPage),
                iconData: Icons.settings,
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: state is TextDocumentLoading
                  ? Center(
                      child: Lottie.asset(
                        'assets/loading.json',
                        width: 150,
                        height: 150,
                      ),
                    )
                  : bloc.documents.isEmpty
                  ? const Center(child: Text('Нет документов'))
                  : ListView.builder(
                      itemCount: bloc.documents.length,
                      itemBuilder: (context, index) {
                        final document = bloc.documents[index];
                        return DocumentCard(
                          document: document,
                          onTap: () => _navigateToDocument(context, document),
                        );
                      },
                    ),
            ),
          ),
          floatingActionButton:
              (defaultTargetPlatform == TargetPlatform.macOS ||
                  defaultTargetPlatform == TargetPlatform.windows ||
                  defaultTargetPlatform == TargetPlatform.linux)
              ? CustomFloatingActionButton(
                  onPressed: () => _showAddDocumentDialog(context),
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
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
      AppNavigator.textDocumentPage,
      arguments: {'document': document, 'canEdit': !isMobile},
    );
  }
}
