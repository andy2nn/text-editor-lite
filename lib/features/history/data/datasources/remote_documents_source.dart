import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';

class RemoteDocumentsSource {
  final SupabaseClient client;
  RemoteDocumentsSource(this.client);

  String? getCurrentUserId() {
    return client.auth.currentUser?.id;
  }

  Future<List<TextDocumentEntity>> fetchAll() async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
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

  Future<void> upload(TextDocumentEntity entity) async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final entityMap = entity.toMap();
    entityMap['user_id'] = user.id;

    await client.from('documents').upsert(entityMap);
  }

  Future<void> update(TextDocumentEntity entity) async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final entityMap = entity.toMap();
    entityMap['user_id'] = user.id;

    await client
        .from('documents')
        .update(entityMap)
        .eq('id', entity.id)
        .eq('user_id', user.id);
  }

  Future<void> delete(String documentId) async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    await client
        .from('documents')
        .delete()
        .eq('id', documentId)
        .eq('user_id', user.id);
  }

  Future<TextDocumentEntity?> fetchById(String documentId) async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
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
