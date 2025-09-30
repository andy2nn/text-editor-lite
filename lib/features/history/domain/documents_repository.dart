import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';

abstract class DocumentsRepository {
  List<TextDocumentEntity> getLocalDocuments();
  Future<TextDocumentEntity> saveDocument(
    TextDocumentEntity entity,
    String? encryptKey,
  );
  Future<void> deleteDocument(int id);
  Future<List<TextDocumentEntity>> fetchRemoteDocuments();
  String decryptTextDocument(TextDocumentEntity entity, String encryptKey);
}
