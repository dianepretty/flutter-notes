import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  StreamSubscription<User?>? _authStreamSubscription;
  bool _isHandlingSignIn = false; // Flag to prevent stream interference

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(const AuthInitial()) {

    // Listen to auth state changes only when not handling sign in
    _authStreamSubscription = _authService.authStateChanges.listen((user) {
      // Don't trigger auth changes while handling sign in/sign up
      if (!_isHandlingSignIn) {
        if (user != null) {
          add(const AuthStatusChanged(isAuthenticated: true));
        } else {
          add(const AuthStatusChanged(isAuthenticated: false));
        }
      }
    });

    // Register event handlers
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);
  }

  // Handle sign up
  void _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    _isHandlingSignIn = true;
    emit(const AuthLoading());
    try {
      UserModel user = await _authService.signUp(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
      print('AuthBloc: Successfully signed up and emitted AuthAuthenticated for user: ${user.email}');
    } catch (e) {
      String errorMessage = _getErrorMessage(e);
      emit(AuthError(message: errorMessage));
      print('AuthBloc Error during SignUp: ${e.toString()}');
    } finally {
      _isHandlingSignIn = false;
    }
  }

  // Handle sign in
  void _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    _isHandlingSignIn = true;
    emit(const AuthLoading());
    try {
      UserModel user = await _authService.signIn(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
      print('AuthBloc: Successfully signed in and emitted AuthAuthenticated for user: ${user.email}');
    } catch (e) {
      String errorMessage = _getErrorMessage(e);
      emit(AuthError(message: errorMessage));
      print('AuthBloc Error during SignIn: ${e.toString()}');
    } finally {
      _isHandlingSignIn = false;
    }
  }

  // Handle sign out
  void _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    _isHandlingSignIn = true;
    emit(const AuthLoading());
    try {
      await _authService.signOut();
      emit(const AuthUnauthenticated());
      print('AuthBloc: Successfully signed out and emitted AuthUnauthenticated.');
    } catch (e) {
      String errorMessage = _getErrorMessage(e);
      emit(AuthError(message: errorMessage));
      print('AuthBloc Error during SignOut: ${e.toString()}');
    } finally {
      _isHandlingSignIn = false;
    }
  }

  // Handle auth status changes
  void _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) async {
    // Don't handle auth status changes while processing sign in/out
    if (_isHandlingSignIn) return;

    if (event.isAuthenticated) {
      try {
        UserModel? user = await _authService.getCurrentUserData();
        if (user != null) {
          emit(AuthAuthenticated(user: user));
          print('AuthBloc: AuthStatusChanged detected authenticated user: ${user.email}');
        } else {
          emit(const AuthUnauthenticated());
          print('AuthBloc: AuthStatusChanged detected unauthenticated state (user null).');
        }
      } catch (e) {
        String errorMessage = _getErrorMessage(e);
        emit(AuthError(message: errorMessage));
        print('AuthBloc Error during AuthStatusChanged: ${e.toString()}');
      }
    } else {
      emit(const AuthUnauthenticated());
      print('AuthBloc: AuthStatusChanged detected unauthenticated state.');
    }
  }

  // Convert Firebase Auth exceptions to user-friendly messages
  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again later.';
        case 'email-already-in-use':
          return 'An account with this email already exists.';
        case 'weak-password':
          return 'Password is too weak. Please choose a stronger password.';
        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled.';
        case 'invalid-credential':
          return 'Invalid email or password. Please check your credentials.';
        case 'network-request-failed':
          return 'Network error. Please check your connection and try again.';
        default:
          return 'Authentication failed. Please try again.';
      }
    }
    return error.toString();
  }

  @override
  Future<void> close() {
    _authStreamSubscription?.cancel();
    return super.close();
  }
}