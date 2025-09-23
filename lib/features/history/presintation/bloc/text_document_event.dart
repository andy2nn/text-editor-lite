import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';

abstract class TextDocumentEvent {}

class LoadTextDocuments extends TextDocumentEvent {}

class AddTextDocument extends TextDocumentEvent {
  final String title;

  AddTextDocument({required this.title});
}

class SaveTextDocument extends TextDocumentEvent {
  final TextDocumentEntity document;
  SaveTextDocument({required this.document});
}

class UpdateTextDocument extends TextDocumentEvent {
  final TextDocumentEntity document;

  UpdateTextDocument({required this.document});
}

class DeleteTextDocument extends TextDocumentEvent {
  final int id;

  DeleteTextDocument({required this.id});
}

class SyncTextDocuments extends TextDocumentEvent {}
