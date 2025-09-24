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
    await local.delete(id);
    await remote.client.from('documents').delete().eq('id', id);
  }

  @override
  Future<List<TextDocumentEntity>> fetchRemoteDocuments() => remote.fetchAll();

  @override
  List<TextDocumentEntity> getLocalDocuments() =>
      local.getAll().map((e) => e.toEntity()).toList();

  @override
  Future<void> saveDocument(TextDocumentEntity entity) async {
    await local.save(TextDocumentModel.fromEntity(entity));
    await remote.upload(entity);
  }

  @override
  Future<void> updateDocument(TextDocumentEntity entity) async {
    await local.update(TextDocumentModel.fromEntity(entity));
    await remote.update(entity);
  }
}
