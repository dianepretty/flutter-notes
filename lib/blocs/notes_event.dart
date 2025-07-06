import 'package:equatable/equatable.dart';
import '../models/note_model.dart'; // Make sure NoteModel is imported

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NotesEvent {
  const LoadNotes();
}

class NotesUpdated extends NotesEvent {
  final List<NoteModel> notes; // This is the expected parameter

  const NotesUpdated({required this.notes});

  @override
  List<Object> get props => [notes];
}

class AddNote extends NotesEvent {
  final String title;
  final String content;

  const AddNote({required this.title, required this.content});

  @override
  List<Object> get props => [title, content];
}

class UpdateNote extends NotesEvent {
  final NoteModel note; // This is the expected parameter

  const UpdateNote({required this.note});

  @override
  List<Object> get props => [note];
}

class DeleteNote extends NotesEvent {
  final String noteId; // This is the expected parameter

  const DeleteNote({required this.noteId});

  @override
  List<Object> get props => [noteId];
}