import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';

abstract class TextDocumentEvent {}

class LoadTextDocuments extends TextDocumentEvent {}

class AddTextDocument extends TextDocumentEvent {
  final TextDocumentEntity document;
  final String? encryptKey;

  AddTextDocument({required this.document, this.encryptKey});
}

class UpdateTextDocument extends TextDocumentEvent {
  final String? encryptKey;
  final TextDocumentEntity document;

  UpdateTextDocument({required this.document, this.encryptKey});
}

class DeleteTextDocument extends TextDocumentEvent {
  final int id;

  DeleteTextDocument({required this.id});
}

class StartTextDocumentEditing extends TextDocumentEvent {}

class CancelTextDocumentEditing extends TextDocumentEvent {}

class SyncTextDocuments extends TextDocumentEvent {}

class DecryptTextDocument extends TextDocumentEvent {
  final String encryptKey;
  final TextDocumentEntity document;
  DecryptTextDocument({required this.document, required this.encryptKey});
}

class HandleScanDocument extends TextDocumentEvent {
  final String scannedData;
  HandleScanDocument({required this.scannedData});
}
