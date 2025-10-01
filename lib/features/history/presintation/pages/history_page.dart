import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:training_cloud_crm_web/core/untils/app_navigator.dart';
import 'package:training_cloud_crm_web/core/untils/snack_bar_helper.dart';
import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_bloc.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_event.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_state.dart';
import 'package:training_cloud_crm_web/widgets/custom_app_bar.dart';
import 'package:training_cloud_crm_web/widgets/custom_button.dart';
import 'package:training_cloud_crm_web/widgets/custom_floating_action_button.dart';
import 'package:training_cloud_crm_web/widgets/custom_icon_button.dart';
import 'package:training_cloud_crm_web/widgets/custom_textfield.dart';
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
          case TextDocumentDecryptred():
            Navigator.pushNamed(
              context,
              AppNavigator.textDocumentPage,
              arguments: {
                'document': state.document,
                'canEdit': !_checkMobilePlatform(),
                'encryptKey': state.encryptKey,
              },
            );
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
                          onLongPress: () => _checkMobilePlatform()
                              ? null
                              : showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    contentPadding: EdgeInsets.all(20),
                                    content: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      width: 300,
                                      child: Column(
                                        spacing: 20,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          QrImageView(
                                            data: document.content,
                                            version: QrVersions.auto,
                                            size: 200,
                                            gapless: false,
                                          ),
                                          CustomButton(
                                            text: 'Закрыть',
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          document: document,
                          onTap: () => _navigateToDocument(context, document),
                        );
                      },
                    ),
            ),
          ),
          floatingActionButton: _checkMobilePlatform()
              ? CustomFloatingActionButton(
                  onPressed: () => showDialog(
                    builder: (context) => MobileScanner(
                      onDetect: (result) {
                        Navigator.pop(context);
                        final document = TextDocumentEntity(
                          id: DateTime.now().millisecondsSinceEpoch,
                          title: "Сканированный документ",
                          content: result.barcodes.first.rawValue ?? '',
                          lastEdited: DateTime.now(),
                        );
                        _navigateToDocument(context, document);
                      },
                    ),
                    context: context,
                  ),
                  child: Icon(Icons.qr_code),
                )
              : CustomFloatingActionButton(
                  onPressed: () => _showAddDocumentDialog(context),
                  child: const Icon(Icons.add),
                ),
        );
      },
    );
  }

  void _showAddDocumentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DocumentDialog(
        onSave: (title, password) {
          context.read<TextDocumentBloc>().add(
            AddTextDocument(title: title, encryptKey: password),
          );
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _navigateToDocument(BuildContext context, TextDocumentEntity document) {
    if (document.isEncrypted != null) {
      final keyEncryptController = TextEditingController();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Введите ключ шифрования'),
          actions: [
            CustomTextField(
              labelText: 'Ключ шифрования',
              controller: keyEncryptController,
            ),
            SizedBox(height: 15),
            CustomButton(
              text: 'Продолжить',
              onPressed: () {
                if (keyEncryptController.text.trim().isEmpty) {
                  SnackBarHelper.showError(
                    context,
                    'Ключ не может быть пустым',
                  );
                } else {
                  context.read<TextDocumentBloc>().add(
                    DecryptTextDocument(
                      document: document,
                      encryptKey: keyEncryptController.text.trim(),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
            ),
            SizedBox(height: 15),
            CustomButton(
              text: 'Отмена',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      Navigator.pushNamed(
        context,
        AppNavigator.textDocumentPage,
        arguments: {'document': document, 'canEdit': !_checkMobilePlatform()},
      );
    }
  }

  bool _checkMobilePlatform() {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      return true;
    }
    return false;
  }
}
