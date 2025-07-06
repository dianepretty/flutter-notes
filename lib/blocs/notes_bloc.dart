import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/notes_service.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesService _notesService;
  StreamSubscription? _notesSubscription; // To listen to real-time updates from Firestore

  NotesBloc({required NotesService notesService})
      : _notesService = notesService,
        super(const NotesInitial()) {
    // Register event handlers
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<NotesUpdated>(_onNotesUpdated); // Handler for internal stream updates
  }

  // Handle loading notes
  void _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) {
    emit(const NotesLoading()); // Emit loading state immediately

    // Cancel existing subscription to prevent duplicates
    _notesSubscription?.cancel();

    // Start listening to the notes stream from NotesService
    _notesSubscription = _notesService.getNotes().listen(
          (notes) {
        // When new notes are received from the stream, add an internal event
        add(NotesUpdated(notes: notes));
      },
      onError: (error) {
        emit(NotesError(message: 'Failed to load notes: $error'));
        print('NotesBloc Error loading notes: $error'); // For debugging
      },
    );
  }

  // Handle adding a note
  void _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    // We don't emit loading here because the UI might already be showing notes.
    // The NotesUpdated event from the stream will update the UI after successful add.
    try {
      await _notesService.addNote(title: event.title, content: event.content);
      // No explicit state change here, the stream listener will trigger NotesUpdated
    } catch (e) {
      emit(NotesError(message: 'Failed to add note: ${e.toString()}'));
      print('NotesBloc Error adding note: ${e.toString()}'); // For debugging
    }
  }

  // Handle updating a note
  void _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    try {
      await _notesService.updateNote(
        noteId: event.note.id,
        newTitle: event.note.title,
        newContent: event.note.content,
      );
      // No explicit state change here, the stream listener will trigger NotesUpdated
    } catch (e) {
      emit(NotesError(message: 'Failed to update note: ${e.toString()}'));
      print('NotesBloc Error updating note: ${e.toString()}'); // For debugging
    }
  }

  // Handle deleting a note
  void _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    try {
      await _notesService.deleteNote(noteId: event.noteId);
      // No explicit state change here, the stream listener will trigger NotesUpdated
    } catch (e) {
      emit(NotesError(message: 'Failed to delete note: ${e.toString()}'));
      print('NotesBloc Error deleting note: ${e.toString()}'); // For debugging
    }
  }

  // Handle internal NotesUpdated event (from the Firestore stream)
  void _onNotesUpdated(NotesUpdated event, Emitter<NotesState> emit) {
    emit(NotesLoaded(notes: event.notes));
    print('NotesBloc: Emitted NotesLoaded with ${event.notes.length} notes.'); // For debugging
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel(); // Cancel the stream subscription
    return super.close();
  }
}