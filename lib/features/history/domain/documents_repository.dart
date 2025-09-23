import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';

abstract class DocumentsRepository {
  List<TextDocumentEntity> getLocalDocuments();
  Future<void> saveDocument(TextDocumentEntity entity);
  Future<void> deleteDocument(int id);
  Future<List<TextDocumentEntity>> fetchRemoteDocuments();
  Future<void> updateDocument(TextDocumentEntity entity);
}
