import 'package:hive/hive.dart';
import 'package:training_cloud_crm_web/core/di/injection.dart';
import 'package:training_cloud_crm_web/core/untils/constans.dart';
import 'package:training_cloud_crm_web/features/auth/domain/entity/user_entity.dart';
import 'package:training_cloud_crm_web/features/auth/domain/model/user_model.dart';
import 'package:training_cloud_crm_web/features/history/data/datasources/local_documents_source.dart';
import 'package:training_cloud_crm_web/features/history/data/datasources/remote_documents_source.dart';
import 'package:training_cloud_crm_web/features/history/domain/documents_repository.dart';
import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';
import 'package:training_cloud_crm_web/features/history/domain/model/text_document_model.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  final LocalDocumentsSource local;
  final RemoteDocumentsSource remote;
  DocumentsRepositoryImpl({required this.local, required this.remote});

  final UserEntity? _user = Injection.getIt
      .get<Box<UserModel>>()
      .get(currentUser)
      ?.toEntity();

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
      return remote.fetchAll(_user);
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
  Future<TextDocumentEntity> saveDocument(
    TextDocumentEntity entity,
    String? encryptKey,
  ) async {
    try {
      if (encryptKey != null) {
        return await local.save(
          TextDocumentModel.fromEntity(entity),
          encryptKey,
        );
      } else {
        await remote.upload(entity, _user);
        return await local.save(
          TextDocumentModel.fromEntity(entity),
          encryptKey,
        );
      }
    } catch (e) {
      throw Exception('Ошибка при сохранении документа: $e');
    }
  }

  @override
  String decryptTextDocument(TextDocumentEntity entity, String encryptKey) =>
      local.decryptData(entity.content, encryptKey);
}
