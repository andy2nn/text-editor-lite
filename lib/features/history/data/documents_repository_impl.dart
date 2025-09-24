import 'package:training_cloud_crm_web/features/history/data/datasources/local_documents_source.dart';
import 'package:training_cloud_crm_web/features/history/data/datasources/remote_documents_source.dart';
import 'package:training_cloud_crm_web/features/history/domain/documents_repository.dart';
import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';
import 'package:training_cloud_crm_web/features/history/domain/model/text_document_model.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  final LocalDocumentsSource local;
  final RemoteDocumentsSource remote;
  DocumentsRepositoryImpl({required this.local, required this.remote});

  @override
  Future<void> deleteDocument(int id) async {
    try {
      await local.delete(id);
      await remote.client.from('documents').delete().eq('id', id);
    } catch (e) {
      throw Exception('Ошибка при удалении документа: $e');
    }
  }

  @override
  Future<List<TextDocumentEntity>> fetchRemoteDocuments() {
    try {
      return remote.fetchAll();
    } catch (e) {
      throw Exception('Ошибка при получении документов с сервера: $e');
    }
  }

  @override
  List<TextDocumentEntity> getLocalDocuments() {
    try {
      return local.getAll().map((e) => e.toEntity()).toList();
    } catch (e) {
      throw Exception('Ошибка при получении локальных документов: $e');
    }
  }

  @override
  Future<void> saveDocument(TextDocumentEntity entity) async {
    try {
      await local.save(TextDocumentModel.fromEntity(entity));
      await remote.upload(entity);
    } catch (e) {
      throw Exception('Ошибка при сохранении документа: $e');
    }
  }

  @override
  Future<void> updateDocument(TextDocumentEntity entity) async {
    try {
      await local.update(TextDocumentModel.fromEntity(entity));
      await remote.update(entity);
    } catch (e) {
      throw Exception('Ошибка при обновлении документа: $e');
    }
  }
}
