import 'dart:convert';

class TextDocumentEntity {
  final int id;
  final String title;
  final String content;
  final DateTime lastEdited;
  final bool? isEncrypted;

  TextDocumentEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.lastEdited,
    this.isEncrypted,
  });

  TextDocumentEntity copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? lastEdited,
    bool? isEncrypted,
  }) {
    return TextDocumentEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      lastEdited: lastEdited ?? this.lastEdited,
      isEncrypted: isEncrypted ?? this.isEncrypted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'last_edited': lastEdited.toIso8601String(),
    };
  }

  factory TextDocumentEntity.fromMap(Map<String, dynamic> map) {
    return TextDocumentEntity(
      id: map['id'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      lastEdited: DateTime.parse(map['last_edited'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory TextDocumentEntity.fromJson(String source) =>
      TextDocumentEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TextDocumentEntity(id: $id, title: $title, content: $content, lastEdited: $lastEdited)';
  }
}
