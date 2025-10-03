// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_document_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TextDocumentModelAdapter extends TypeAdapter<TextDocumentModel> {
  @override
  final int typeId = 0;

  @override
  TextDocumentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextDocumentModel(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      lastEdited: fields[3] as DateTime,
      isEncrypted: fields[4] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, TextDocumentModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.lastEdited)
      ..writeByte(4)
      ..write(obj.isEncrypted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextDocumentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
