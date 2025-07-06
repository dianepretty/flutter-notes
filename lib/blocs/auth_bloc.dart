import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  late StreamSubscription<User?> _authStreamSubscription;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(const AuthInitial()) {

    // Listen to auth state changes
    _authStreamSubscription = _authService.authStateChanges.listen((user) {
      if (user != null) {
        add(const AuthStatusChanged(isAuthenticated: true));
      } else {
        add(const AuthStatusChanged(isAuthenticated: false));
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
    emit(const AuthLoading());
    try {
      UserModel user = await _authService.signUp(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
      print('AuthBloc: Successfully signed up and emitted AuthAuthenticated for user: ${user.email}'); // ADDED PRINT
    } catch (e) {
      emit(AuthError(message: e.toString()));
      print('AuthBloc Error during SignUp: ${e.toString()}'); // ADDED PRINT
    }
  }

  // Handle sign in
  void _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      UserModel user = await _authService.signIn(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
      print('AuthBloc: Successfully signed in and emitted AuthAuthenticated for user: ${user.email}'); // ADDED PRINT
    } catch (e) {
      emit(AuthError(message: e.toString()));
      print('AuthBloc Error during SignIn: ${e.toString()}'); // ADDED PRINT
    }
  }

  // Handle sign out
  void _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _authService.signOut();
      emit(const AuthUnauthenticated());
      print('AuthBloc: Successfully signed out and emitted AuthUnauthenticated.'); // ADDED PRINT
    } catch (e) {
      emit(AuthError(message: e.toString()));
      print('AuthBloc Error during SignOut: ${e.toString()}'); // ADDED PRINT
    }
  }

  // Handle auth status changes
  void _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) async {
    if (event.isAuthenticated) {
      try {
        UserModel? user = await _authService.getCurrentUserData();
        if (user != null) {
          emit(AuthAuthenticated(user: user));
          print('AuthBloc: AuthStatusChanged detected authenticated user: ${user.email}'); // ADDED PRINT
        } else {
          emit(const AuthUnauthenticated());
          print('AuthBloc: AuthStatusChanged detected unauthenticated state (user null).'); // ADDED PRINT
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
        print('AuthBloc Error during AuthStatusChanged: ${e.toString()}'); // ADDED PRINT
      }
    } else {
      emit(const AuthUnauthenticated());
      print('AuthBloc: AuthStatusChanged detected unauthenticated state.'); // ADDED PRINT
    }
  }

  @override
  Future<void> close() {
    _authStreamSubscription.cancel();
    return super.close();
  }
}