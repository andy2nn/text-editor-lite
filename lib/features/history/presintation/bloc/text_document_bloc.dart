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
    on<SaveTextDocument>(_saveTextDocument);
    on<UpdateTextDocument>(_updateTextDocument);
    on<DeleteTextDocument>(_deleteTextDocument);
    on<SyncTextDocuments>(_syncTextDocuments);
    on<AddTextDocument>(_addTextDocument);
    on<StartTextDocumentEditing>(_startTextDocumentEditing);
    on<CancelTextDocumentEditing>(_cancelTextDocumentEditing);
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
    );

    await docRepository
        .saveDocument(document)
        .then((_) {
          _listDocuments.add(document);
          emit(TextDocumentAdded(document: document));
        })
        .catchError(((e) {
          emit(TextDocumentError(e.toString()));
          return null;
        }));
  }

  Future<void> _loadTextDocuments(
    LoadTextDocuments event,
    Emitter<TextDocumentState> emit,
  ) async {
    emit(TextDocumentLoading());

    _listDocuments = docRepository.getLocalDocuments();
    emit(TextDocumentLoaded());
  }

  Future<void> _saveTextDocument(
    SaveTextDocument event,
    Emitter<TextDocumentState> emit,
  ) async {
    await docRepository
        .saveDocument(event.document)
        .catchError((e) => emit(TextDocumentError(e.toString())));
  }

  Future<void> _updateTextDocument(
    UpdateTextDocument event,
    Emitter<TextDocumentState> emit,
  ) async {
    await docRepository
        .updateDocument(event.document)
        .then((_) {
          emit(TextDocumentEditingSuccess());
          final index = _listDocuments.indexWhere(
            (doc) => doc.id == event.document.id,
          );
          if (index != -1) {
            _listDocuments[index] = event.document;
          }
        })
        .catchError(((e) {
          emit(TextDocumentError(e.toString()));
          return null;
        }));
  }

  Future<void> _deleteTextDocument(
    DeleteTextDocument event,
    Emitter<TextDocumentState> emit,
  ) async {
    await docRepository
        .deleteDocument(event.id)
        .then((_) {
          emit((TextDocumentDeleted()));
          _listDocuments.removeWhere((doc) => doc.id == event.id);
        })
        .catchError(((e) {
          emit(TextDocumentError(e.toString()));
          return null;
        }));
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
            final localDocIndex = mergedDocuments.indexWhere(
              (doc) => doc.id == remoteDoc.id,
            );

            if (localDocIndex == -1) {
              await docRepository.saveDocument(remoteDoc);
              mergedDocuments.add(remoteDoc);
            } else {
              final localDoc = mergedDocuments[localDocIndex];
              if (localDoc.lastEdited.isBefore(remoteDoc.lastEdited)) {
                await docRepository.updateDocument(remoteDoc);
                mergedDocuments[localDocIndex] = remoteDoc;
              }
            }
          }

          for (TextDocumentEntity localDoc in localDocuments) {
            final remoteDocExists = remoteDocuments.any(
              (doc) => doc.id == localDoc.id,
            );
            if (!remoteDocExists) {
              await docRepository.saveDocument(localDoc);
              if (!mergedDocuments.any((doc) => doc.id == localDoc.id)) {
                mergedDocuments.add(localDoc);
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
