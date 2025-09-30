import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';
import 'package:training_cloud_crm_web/features/history/domain/model/text_document_model.dart';

class LocalDocumentsSource {
  final Box<TextDocumentModel> box;
  LocalDocumentsSource(this.box);

  List<TextDocumentModel> getAll() {
    return box.values.toList();
  }

  Future<TextDocumentEntity> save(
    TextDocumentModel model,
    String? encryptKey,
  ) async {
    if (encryptKey != null) {
      final encryptedModel = model.copyWith(
        isEncrypted: true,
        content: encryptData(model.content, encryptKey),
      );
      await box.put(encryptedModel.id, encryptedModel);
      return encryptedModel.toEntity();
    } else {
      await box.put(model.id, model);
      return model.toEntity();
    }
  }

  Future<void> delete(int id) async {
    await box.delete(id.toString());
  }

  String encryptData(String data, String encryptKey) {
    final dataBytes = utf8.encode(data);
    final keyBytes = sha256.convert(utf8.encode(encryptKey)).bytes;

    final result = Uint8List(dataBytes.length);
    for (int i = 0; i < dataBytes.length; i++) {
      result[i] = dataBytes[i] ^ keyBytes[i % keyBytes.length];
    }

    return base64.encode(result);
  }

  String decryptData(String encryptedData, String encryptKey) {
    try {
      final dataBytes = base64.decode(encryptedData);
      final keyBytes = sha256.convert(utf8.encode(encryptKey)).bytes;

      final result = Uint8List(dataBytes.length);
      for (int i = 0; i < dataBytes.length; i++) {
        result[i] = dataBytes[i] ^ keyBytes[i % keyBytes.length];
      }

      return utf8.decode(result);
    } catch (e) {
      throw Exception('Ошибка расшифровки: ${e.toString()}');
    }
  }
}
