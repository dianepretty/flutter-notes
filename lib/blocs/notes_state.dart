import 'package:equatable/equatable.dart';
import '../models/note_model.dart'; // Import NoteModel

// Abstract base class for all Notes states
abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

// Initial state, before any notes are loaded
class NotesInitial extends NotesState {
  const NotesInitial();
}

// State indicating notes are currently being loaded
class NotesLoading extends NotesState {
  const NotesLoading();
}

// State indicating notes have been successfully loaded
class NotesLoaded extends NotesState {
  final List<NoteModel> notes;

  const NotesLoaded({this.notes = const []}); // Initialize with empty list

  @override
  List<Object> get props => [notes];
}

// State indicating an error occurred during notes operations
class NotesError extends NotesState {
  final String message;

  const NotesError({required this.message});

  @override
  List<Object> get props => [message];
}