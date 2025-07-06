import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/notes_bloc.dart';
import '../blocs/notes_event.dart';
import '../blocs/notes_state.dart';
import '../models/note_model.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  NoteModel? _editingNote;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _showAddNoteForm({required BuildContext parentContext, NoteModel? noteToEdit}) {
    if (noteToEdit != null) {
      _titleController.text = noteToEdit.title;
      _contentController.text = noteToEdit.content;
      _editingNote = noteToEdit;
    } else {
      _titleController.clear();
      _contentController.clear();
      _editingNote = null;
    }

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(_editingNote == null ? 'Add New Note' : 'Edit Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Note Title',
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your note content here...',
                    labelText: 'Content',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _titleController.clear();
                _contentController.clear();
                _editingNote = null;
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: Text(_editingNote == null ? 'Add' : 'Save'),
              onPressed: () {
                final String title = _titleController.text.trim();
                final String content = _contentController.text.trim();

                if (title.isEmpty || content.isEmpty) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    const SnackBar(content: Text('Title and content cannot be empty!')),
                  );
                  return;
                }

                if (_editingNote != null) {
                  parentContext.read<NotesBloc>().add(
                    UpdateNote(
                      note: _editingNote!.copyWith(
                        title: title,
                        content: content,
                      ),
                    ),
                  );
                } else {
                  parentContext.read<NotesBloc>().add(
                    AddNote(title: title, content: content),
                  );
                }
                _titleController.clear();
                _contentController.clear();
                _editingNote = null;
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // NEW METHOD: Confirmation dialog for deletion
  void _confirmDelete({required BuildContext parentContext, required String noteId, required String noteTitle}) {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the note "${noteTitle}"? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red), // Make delete button red
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog first
                // Dispatch DeleteNote event to NotesBloc
                parentContext.read<NotesBloc>().add(
                  DeleteNote(noteId: noteId),
                );
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(content: Text('Note deleted!')),
                );
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final BuildContext notesScreenContext = context;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteForm(parentContext: notesScreenContext),
        backgroundColor: const Color(0xFF395BFE),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Notes",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF395BFE),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthBloc>().add(const SignOutRequested());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: BlocBuilder<NotesBloc, NotesState>(
            builder: (context, state) {
              final BuildContext blocBuilderContext = context;

              if (state is NotesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is NotesLoaded) {
                if (state.notes.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nothing here yet—tap ➕ to add a note.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.notes.length,
                  itemBuilder: (context, index) {
                    final note = state.notes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              note.content,
                              style: const TextStyle(fontSize: 16),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 24, color: Colors.amber),
                                  onPressed: () {
                                    _showAddNoteForm(parentContext: blocBuilderContext, noteToEdit: note);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 24, color: Colors.red),
                                  onPressed: () {
                                    // Call the new confirmation dialog
                                    _confirmDelete(
                                      parentContext: blocBuilderContext,
                                      noteId: note.id,
                                      noteTitle: note.title,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is NotesError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                );
              }
              return const Center(
                child: Text(
                  "Preparing your notes...",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}