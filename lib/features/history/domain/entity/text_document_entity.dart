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

  static bool isDeepLink(String data) {
    try {
      final uri = Uri.parse(data);
      return uri.scheme == 'io.supabase.flutterquickstart' &&
          (uri.host == 'document' || uri.host == 'open');
    } catch (e) {
      return false;
    }
  }

  factory TextDocumentEntity.fromDeepLink(Uri uri) {
    final params = uri.queryParameters;

    return TextDocumentEntity(
      id: int.parse(params['id']!),
      title: Uri.decodeComponent(params['title']!),
      content: utf8.decode(base64Url.decode(params['content']!)),
      lastEdited: DateTime.parse(params['last_edited']!),
      isEncrypted: params['is_encrypted'] == 'true',
    );
  }

  String toDeepLink() {
    final encodedTitle = Uri.encodeComponent(title);
    final encodedContent = base64Url.encode(utf8.encode(content));

    return 'io.supabase.flutterquickstart://document/details?'
        'id=$id'
        '&title=$encodedTitle'
        '&content=$encodedContent'
        '&last_edited=${lastEdited.toIso8601String()}'
        '&is_encrypted=${isEncrypted ?? false}';
  }

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
