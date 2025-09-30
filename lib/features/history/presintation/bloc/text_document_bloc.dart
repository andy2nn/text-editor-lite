import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_cloud_crm_web/features/history/domain/documents_repository.dart';
import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_event.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_state.dart';

class TextDocumentBloc extends Bloc<TextDocumentEvent, TextDocumentState> {
  final DocumentsRepository docRepository;

  List<TextDocumentEntity> _listDocuments = [];

  List<TextDocumentEntity> get documents => _listDocuments;

  TextDocumentBloc({required this.docRepository})
    : super(TextDocumentInitial()) {
    on<LoadTextDocuments>(_loadTextDocuments);
    on<UpdateTextDocument>(_updateTextDocument);
    on<DeleteTextDocument>(_deleteTextDocument);
    on<SyncTextDocuments>(_syncTextDocuments);
    on<AddTextDocument>(_addTextDocument);
    on<StartTextDocumentEditing>(_startTextDocumentEditing);
    on<CancelTextDocumentEditing>(_cancelTextDocumentEditing);
    on<DecryptTextDocument>(_decryptTextDocument);
  }

  Future<void> _decryptTextDocument(
    DecryptTextDocument event,
    Emitter<TextDocumentState> emit,
  ) async {
    final String decryptData = docRepository.decryptTextDocument(
      event.document,
      event.encryptKey,
    );
    emit(
      TextDocumentDecryptred(
        document: event.document.copyWith(content: decryptData),
        encryptKey: event.encryptKey,
      ),
    );
  }

  Future<void> _startTextDocumentEditing(
    StartTextDocumentEditing event,
    Emitter<TextDocumentState> emit,
  ) async {
    emit(TextDocumentEditing());
  }

  Future<void> _cancelTextDocumentEditing(
    CancelTextDocumentEditing event,
    Emitter<TextDocumentState> emit,
  ) async {
    emit(TextDocumentEditingCancel());
  }

  Future<void> _addTextDocument(
    AddTextDocument event,
    Emitter<TextDocumentState> emit,
  ) async {
    final document = TextDocumentEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      title: event.title,
      content: '',
      lastEdited: DateTime.now(),
      isEncrypted: event.encryptKey != null,
    );
    await docRepository
        .saveDocument(document, event.encryptKey)
        .then((savedDocument) {
          _listDocuments.add(savedDocument);
          emit(TextDocumentAdded(document: savedDocument));
        })
        .catchError((e) {
          emit(TextDocumentError(e.toString()));
          return null;
        });
  }

  Future<void> _loadTextDocuments(
    LoadTextDocuments event,
    Emitter<TextDocumentState> emit,
  ) async {
    emit(TextDocumentLoading());
    _listDocuments = docRepository.getLocalDocuments();
    emit(TextDocumentLoaded());
  }

  Future<void> _updateTextDocument(
    UpdateTextDocument event,
    Emitter<TextDocumentState> emit,
  ) async {
    await docRepository
        .saveDocument(event.document, event.encryptKey)
        .then((savedDocument) {
          emit(TextDocumentEditingSuccess());
          final index = _listDocuments.indexWhere(
            (doc) => doc.id == savedDocument.id,
          );
          if (index != -1) {
            _listDocuments[index] = savedDocument;
          }
        })
        .catchError((e) {
          emit(TextDocumentError(e.toString()));
          return null;
        });
  }

  Future<void> _deleteTextDocument(
    DeleteTextDocument event,
    Emitter<TextDocumentState> emit,
  ) async {
    await docRepository
        .deleteDocument(event.id)
        .then((_) {
          emit(TextDocumentDeleted());
          _listDocuments.removeWhere((doc) => doc.id == event.id);
        })
        .catchError((e) {
          emit(TextDocumentError(e.toString()));
          return null;
        });
  }

  Future<void> _syncTextDocuments(
    SyncTextDocuments event,
    Emitter<TextDocumentState> emit,
  ) async {
    emit(TextDocumentLoading());
    await docRepository
        .fetchRemoteDocuments()
        .then((remoteDocuments) async {
          final localDocuments = docRepository.getLocalDocuments();
          final mergedDocuments = List<TextDocumentEntity>.from(localDocuments);

          for (TextDocumentEntity remoteDoc in remoteDocuments) {
            if (remoteDoc.isEncrypted == null) continue;
            final localDocIndex = mergedDocuments.indexWhere(
              (doc) => doc.id == remoteDoc.id,
            );
            if (localDocIndex == -1) {
              final savedDocument = await docRepository.saveDocument(
                remoteDoc,
                null,
              );
              mergedDocuments.add(savedDocument);
            } else {
              final localDoc = mergedDocuments[localDocIndex];
              if (localDoc.lastEdited.isBefore(remoteDoc.lastEdited)) {
                final savedDocument = await docRepository.saveDocument(
                  remoteDoc,
                  null,
                );
                mergedDocuments[localDocIndex] = savedDocument;
              }
            }
          }

          for (TextDocumentEntity localDoc in localDocuments) {
            if (localDoc.isEncrypted == null) continue;
            final remoteDocExists = remoteDocuments.any(
              (doc) => doc.id == localDoc.id,
            );
            if (!remoteDocExists) {
              final savedDocument = await docRepository.saveDocument(
                localDoc,
                null,
              );
              if (!mergedDocuments.any((doc) => doc.id == savedDocument.id)) {
                mergedDocuments.add(savedDocument);
              }
            }
          }

          _listDocuments = mergedDocuments;
          emit(TextDocumentLoaded());
        })
        .catchError((e) {
          emit(TextDocumentError(e.toString()));
          return null;
        });
  }
}
