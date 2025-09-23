import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';

class RemoteDocumentsSource {
  final SupabaseClient client;
  RemoteDocumentsSource(this.client);

  Future<List<TextDocumentEntity>> fetchAll() async {
    final response = await client.from('documents').select();
    return (response as List)
        .map((e) => TextDocumentEntity.fromMap(e))
        .toList();
  }

  Future<void> upload(TextDocumentEntity entity) async {
    await client.from('documents').upsert(entity.toMap());
  }
}
