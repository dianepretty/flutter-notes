import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/screens/login.dart';
import 'package:flutter_notes/screens/notes.dart';
import 'package:flutter_notes/screens/sign_up.dart';
import 'package:flutter_notes/services/auth_service.dart';
import 'package:flutter_notes/blocs/auth_bloc.dart';
import 'package:flutter_notes/blocs/auth_state.dart';

import 'blocs/auth_event.dart';
import 'firebase_options.dart';

final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authService: AuthService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthAuthenticated) {
          // User is logged in, show notes screen
          return const NotesScreen();
        } else {
          // User is not logged in, show login screen by default
          return const Login();
        }
      },
    );
  }
}

// Placeholder for NotesScreen if you don't have it yet
class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const SignOutRequested());
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Notes Screen - Coming Soon!'),
      ),
    );
  }
}