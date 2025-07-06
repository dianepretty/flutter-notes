import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart'; // Import the NoteModel we just created

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> addNote({required String title, required String content}) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not logged in.');
    }


    DocumentReference docRef = await _firestore.collection('notes').add({
      'userId': userId,
      'title': title,
      'content': content,
      'timestamp': Timestamp.now(), // Server timestamp
    });

  }

  // Get a stream of notes for the current user
  Stream<List<NoteModel>> getNotes() {
    final userId = currentUserId;
    if (userId == null) {
      // If no user is logged in, return an empty stream
      return Stream.value([]);
    }

    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId) // Filter notes by current user
        .orderBy('timestamp', descending: true) // Order notes by newest first
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => NoteModel.fromDocumentSnapshot(doc)).toList();
    });
  }

  // Update an existing note
  Future<void> updateNote({required String noteId, required String newTitle, required String newContent}) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not logged in.');
    }

    await _firestore.collection('notes').doc(noteId).update({
      'title': newTitle,
      'content': newContent,
      'timestamp': Timestamp.now(), // Update timestamp on modification
    });
  }

  // Delete a note
  Future<void> deleteNote({required String noteId}) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not logged in.');
    }



    await _firestore.collection('notes').doc(noteId).delete();
  }
}