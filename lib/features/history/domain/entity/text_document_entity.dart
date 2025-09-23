import 'dart:convert';

class TextDocumentEntity {
  final String id;
  final String title;
  final String content;
  final DateTime lastEdited;

  TextDocumentEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.lastEdited,
  });

  TextDocumentEntity copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? lastEdited,
  }) {
    return TextDocumentEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      lastEdited: lastEdited ?? this.lastEdited,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'lastEdited': lastEdited.millisecondsSinceEpoch,
    };
  }

  factory TextDocumentEntity.fromMap(Map<String, dynamic> map) {
    return TextDocumentEntity(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      lastEdited: DateTime.fromMillisecondsSinceEpoch(map['lastEdited'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory TextDocumentEntity.fromJson(String source) =>
      TextDocumentEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TextDocumentEntity(id: $id, title: $title, content: $content, lastEdited: $lastEdited)';
  }

  @override
  bool operator ==(covariant TextDocumentEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.content == content &&
        other.lastEdited == lastEdited;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        content.hashCode ^
        lastEdited.hashCode;
  }
}
