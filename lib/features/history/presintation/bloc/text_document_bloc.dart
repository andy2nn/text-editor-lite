import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_cloud_crm_web/features/history/domain/documents_repository.dart';
import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_event.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_state.dart';

class TextDocumentBloc extends Bloc<TextDocumentEvent, TextDocumentState> {
  final DocumentsRepository docRepository;

  TextDocumentBloc({required this.docRepository})
    : super(TextDocumentInitial()) {
    on<LoadTextDocuments>(_loadTextDocuments);
    on<SaveTextDocument>(_saveTextDocument);
    on<UpdateTextDocument>(_updateTextDocument);
    on<DeleteTextDocument>(_deleteTextDocument);
    on<SyncTextDocuments>(_syncTextDocuments);
    on<AddTextDocument>(_addTextDocument);
  }

  Future<void> _addTextDocument(
    AddTextDocument event,
    Emitter<TextDocumentState> emit,
  ) async {
    try {
      final document = TextDocumentEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        title: event.title,
        content: '',
        lastEdited: DateTime.now(),
      );

      await docRepository.saveDocument(document);
      final documents = docRepository.getLocalDocuments();
      emit(TextDocumentLoaded(documents: documents));
    } catch (e) {
      emit(TextDocumentError(e.toString()));
    }
  }

  Future<void> _loadTextDocuments(
    LoadTextDocuments event,
    Emitter<TextDocumentState> emit,
  ) async {
    emit(TextDocumentLoading());
    try {
      final documents = docRepository.getLocalDocuments();
      emit(TextDocumentLoaded(documents: documents));
    } catch (e) {
      emit(TextDocumentError(e.toString()));
    }
  }

  Future<void> _saveTextDocument(
    SaveTextDocument event,
    Emitter<TextDocumentState> emit,
  ) async {
    try {
      await docRepository.saveDocument(event.document);
      final documents = docRepository.getLocalDocuments();
      emit(TextDocumentLoaded(documents: documents));
    } catch (e) {
      emit(TextDocumentError(e.toString()));
    }
  }

  Future<void> _updateTextDocument(
    UpdateTextDocument event,
    Emitter<TextDocumentState> emit,
  ) async {
    try {
      await docRepository.updateDocument(event.document);
      final documents = docRepository.getLocalDocuments();
      emit(TextDocumentLoaded(documents: documents));
    } catch (e) {
      emit(TextDocumentError(e.toString()));
    }
  }

  Future<void> _deleteTextDocument(
    DeleteTextDocument event,
    Emitter<TextDocumentState> emit,
  ) async {
    try {
      //TODO: удаление работает некорректно
      await docRepository.deleteDocument(event.id);
      final documents = docRepository.getLocalDocuments();
      emit(TextDocumentLoaded(documents: documents));
    } catch (e) {
      emit(TextDocumentError(e.toString()));
    }
  }

  Future<void> _syncTextDocuments(
    SyncTextDocuments event,
    Emitter<TextDocumentState> emit,
  ) async {
    emit(TextDocumentLoading());
    try {
      final remoteDocuments = await docRepository.fetchRemoteDocuments();
      final localDocuments = docRepository.getLocalDocuments();

      for (var remoteDoc in remoteDocuments) {
        final matchingLocalDocs = localDocuments
            .where((doc) => doc.id == remoteDoc.id)
            .toList();

        if (matchingLocalDocs.isEmpty) {
          await docRepository.saveDocument(remoteDoc);
        } else {
          final localDoc = matchingLocalDocs.first;
          if (localDoc.lastEdited.isBefore(remoteDoc.lastEdited)) {
            await docRepository.updateDocument(remoteDoc);
          }
        }
      }

      final updatedDocuments = docRepository.getLocalDocuments();
      emit(TextDocumentLoaded(documents: updatedDocuments));
    } catch (e) {
      emit(TextDocumentError(e.toString()));
    }
  }
}
