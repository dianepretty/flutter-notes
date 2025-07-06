import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirestoreService _firestoreService;

  AuthBloc({required FirestoreService firestoreService})
      : _firestoreService = firestoreService,
        super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    // Add handlers for other events like SignInRequested, SignOutRequested
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      // Basic validation (can be moved to a separate validator utility)
      if (event.firstName.isEmpty || event.lastName.isEmpty || event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthFailure('Please fill in all fields.'));
        return;
      }
      if (!event.email.contains('@') || !event.email.contains('.')) {
        emit(const AuthFailure('Please enter a valid email address.'));
        return;
      }
      if (event.password.length < 6) {
        emit(const AuthFailure('Password must be at least 6 characters long.'));
        return;
      }

      // Call the Firebase service to create the user
      UserCredential userCredential = await _firestoreService.signUpWithEmailAndPassword(event.email, event.password);

      // Optionally, save additional user data (first name, last name) to Firestore
      // You'll need to uncomment and implement the saveUserData method in FirestoreService
      // if (userCredential.user != null) {
      //   await _firestoreService.saveUserData(userCredential.user!.uid, event.firstName, event.lastName);
      // }

      emit(const AuthSuccess('Sign up successful!'));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = e.message ?? 'An unknown error occurred during sign up.';
      }
      emit(AuthFailure(errorMessage));
    } catch (e) {
      emit(AuthFailure('An unexpected error occurred: $e'));
    }
  }
}