import 'package:hive/hive.dart';
import 'package:training_cloud_crm_web/features/history/domain/model/text_document_model.dart';

class LocalDocumentsSource {
  final Box<TextDocumentModel> box;
  LocalDocumentsSource(this.box);

  List<TextDocumentModel> getAll() {
    return box.values.toList();
  }

  Future<void> save(TextDocumentModel model) async {
    await box.put(model.id, model);
  }

  Future<void> delete(int id) async {
    await box.delete(id);
  }

  Future<void> update(TextDocumentModel model) async {
    await box.put(model.id, model);
  }
}
