import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance; // Keep if you plan to save user data to Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // This will be provided by the Canvas environment.
  // In a real Flutter app, you might get this from environment variables or a config file.
  final String _appId = 'my_note_app_id'; // Placeholder for __app_id

  // Get the current user ID. If not authenticated, sign in anonymously.
  Future<String> getUserId() async {
    User? user = _auth.currentUser;
    if (user == null) {
      await signInAnonymously();
      user = _auth.currentUser;
    }
    return user?.uid ?? 'anonymous_user';
  }

  // Signs in an anonymous user if no user is currently signed in.
  Future<void> signInAnonymously() async {
    if (_auth.currentUser == null) {
      try {
        await _auth.signInAnonymously();
        print("Signed in anonymously with UID: ${_auth.currentUser?.uid}");
      } catch (e) {
        print("Error signing in anonymously: $e");
      }
    }
  }

  // Method for email/password sign up
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User signed up: ${userCredential.user?.email}");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
      throw Exception(e.message ?? 'An unknown error occurred during sign up.');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

// --- Removed all note-related methods ---
// If you plan to save first/last name to Firestore after sign-up,
// you would add a method here, e.g.:
/*
  Future<void> saveUserData(String userId, String firstName, String lastName) async {
    await _db.collection('artifacts').doc(_appId).collection('users').doc(userId).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': _auth.currentUser?.email,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
  */
}