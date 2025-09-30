import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';

abstract class TextDocumentState {}

class TextDocumentInitial extends TextDocumentState {}

class TextDocumentLoading extends TextDocumentState {}

class TextDocumentLoaded extends TextDocumentState {}

class TextDocumentAdded extends TextDocumentState {
  final TextDocumentEntity document;
  TextDocumentAdded({required this.document});
}

class TextDocumentError extends TextDocumentState {
  final String errorMessage;

  TextDocumentError(this.errorMessage);
}

class TextDocumentDeleted extends TextDocumentState {}

class TextDocumentEditing extends TextDocumentState {}

class TextDocumentEditingCancel extends TextDocumentState {}

class TextDocumentEditingSuccess extends TextDocumentState {}

class TextDocumentDecryptred extends TextDocumentState {
  final String encryptKey;
  final TextDocumentEntity document;
  TextDocumentDecryptred({required this.document, required this.encryptKey});
}
