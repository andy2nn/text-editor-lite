import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:training_cloud_crm_web/features/auth/domain/entity/user_entity.dart';
import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';

class RemoteDocumentsSource {
  final SupabaseClient client;
  RemoteDocumentsSource(this.client);

  Future<List<TextDocumentEntity>> fetchAll(UserEntity? user) async {
    if (user == null) {
      throw Exception('Пользователь не аутентифицирован');
    }
    final response = await client
        .from('documents')
        .select()
        .eq('user_id', user.id)
        .order('last_edited', ascending: false);

    return (response as List)
        .map((e) => TextDocumentEntity.fromMap(e))
        .toList();
  }

  Future<void> upload(TextDocumentEntity document, UserEntity? user) async {
    if (user == null) {
      throw Exception('Пользователь не аутентифицирован');
    }
    final documentMap = document.toMap();
    documentMap['user_id'] = user.id;

    await client.from('documents').upsert(documentMap);
  }

  Future<void> update(TextDocumentEntity document, UserEntity? user) async {
    if (user == null) {
      throw Exception('Пользователь не аутентифицирован');
    }
    final documentMap = document.toMap();
    documentMap['user_id'] = user.id;

    await client
        .from('documents')
        .update(documentMap)
        .eq('id', document.id)
        .eq('user_id', user.id);
  }

  Future<void> delete(String documentId, UserEntity? user) async {
    if (user == null) {
      throw Exception('Пользователь не аутентифицирован');
    }
    await client
        .from('documents')
        .delete()
        .eq('id', documentId)
        .eq('user_id', user.id);
  }

  Future<TextDocumentEntity?> fetchById(
    String documentId,
    UserEntity? user,
  ) async {
    if (user == null) {
      throw Exception('Пользователь не аутентифицирован');
    }
    final response = await client
        .from('documents')
        .select()
        .eq('id', documentId)
        .eq('user_id', user.id)
        .single();

    return TextDocumentEntity.fromMap(response);
  }
}
