import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  // List to store notes
  final List<String> _notes = ["Hello", "My first note", "Another note"];
  // Controller for the TextField in the AlertDialog
  final TextEditingController _noteController = TextEditingController();

  // New: Variable to track which note is being edited. Null means adding a new note.
  int? _editingIndex;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // Modified function to show the add/edit note form
  void _showAddNoteForm({int? index, String? currentNote}) {
    // If editing, pre-fill the controller and set the editing index
    if (index != null && currentNote != null) {
      _noteController.text = currentNote;
      _editingIndex = index;
    } else {
      _noteController.clear(); // Clear for new note
      _editingIndex = null; // Ensure no editing index is set
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_editingIndex == null ? 'Add New Note' : 'Edit Note'),
          content: TextField(
            controller: _noteController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter your note here...',
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null, // Allow multiline input
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _noteController.clear(); // Clear input field
                _editingIndex = null; // Reset editing index
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            ElevatedButton(
              child: Text(_editingIndex == null ? 'Add' : 'Save'),
              onPressed: () {
                final String updatedNote = _noteController.text.trim();
                if (updatedNote.isNotEmpty) {
                  setState(() {
                    if (_editingIndex != null) {
                      // If editing, update the existing note
                      _notes[_editingIndex!] = updatedNote;
                    } else {
                      // Otherwise, add a new note
                      _notes.add(updatedNote);
                    }
                  });
                  _noteController.clear(); // Clear controller for next use
                  _editingIndex = null; // Reset editing index
                  Navigator.of(context).pop(); // Close dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Note cannot be empty!')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteForm(), // Call without arguments to add a new note
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: _notes.isEmpty
              ? const Center(
            child: Text(
              "No notes yet. Click '+' to add one!",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
              : ListView.builder(
            itemCount: _notes.length,
            itemBuilder: (context, index) {
              final note = _notes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          note,
                          style: const TextStyle(fontSize: 16),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 24, color: Colors.amber),
                        onPressed: () {
                          // Call with index and current note for editing
                          _showAddNoteForm(index: index, currentNote: note);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 24, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _notes.removeAt(index); // Delete the note
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Note deleted!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}