import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';

abstract class TextDocumentState {}

class TextDocumentInitial extends TextDocumentState {}

class TextDocumentLoading extends TextDocumentState {}

class TextDocumentLoaded extends TextDocumentState {
  final List<TextDocumentEntity> documents;
  TextDocumentLoaded({this.documents = const []});
}

class TextDocumentAdded extends TextDocumentState {
  final TextDocumentEntity document;
  TextDocumentAdded({required this.document});
}

class TextDocumentError extends TextDocumentState {
  final String errorMessage;

  TextDocumentError(this.errorMessage);
}
