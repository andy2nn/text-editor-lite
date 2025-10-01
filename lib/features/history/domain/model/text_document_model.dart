import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';

part 'text_document_model.g.dart';

@HiveType(typeId: 0)
class TextDocumentModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final DateTime lastEdited;
  @HiveField(4)
  final bool? isEncrypted;

  TextDocumentModel({
    required this.id,
    required this.title,
    required this.content,
    required this.lastEdited,
    this.isEncrypted,
  });

  TextDocumentModel copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? lastEdited,
    bool? isEncrypted,
  }) {
    return TextDocumentModel(
      isEncrypted: isEncrypted ?? this.isEncrypted,
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      lastEdited: lastEdited ?? this.lastEdited,
    );
  }

  TextDocumentEntity toEntity() {
    return TextDocumentEntity(
      id: int.parse(id),
      title: title,
      content: content,
      lastEdited: lastEdited,
      isEncrypted: isEncrypted,
    );
  }

  static TextDocumentModel fromEntity(TextDocumentEntity entity) {
    return TextDocumentModel(
      id: entity.id.toString(),
      title: entity.title,
      content: entity.content,
      lastEdited: entity.lastEdited,
      isEncrypted: entity.isEncrypted,
    );
  }
}
