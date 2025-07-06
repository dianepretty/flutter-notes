import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/screens/login.dart';
import 'package:flutter_notes/screens/notes.dart'; // This should be `Notes` as per your file name
import 'package:flutter_notes/screens/sign_up.dart';
import 'package:flutter_notes/services/auth_service.dart';
import 'package:flutter_notes/blocs/auth_bloc.dart';
import 'package:flutter_notes/blocs/auth_state.dart';

import 'blocs/auth_event.dart';
import 'blocs/notes_event.dart';
import 'firebase_options.dart';

// NEW IMPORTS FOR NOTES BLOC
import 'package:flutter_notes/blocs/notes_bloc.dart';
import 'package:flutter_notes/services/notes_service.dart';

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
    // Instantiate AuthService and NotesService once
    final AuthService authService = AuthService();
    final NotesService notesService = NotesService();

    return MultiBlocProvider( // Use MultiBlocProvider for multiple providers
      providers: [
        BlocProvider( // Provide AuthBloc
          create: (context) => AuthBloc(authService: authService),
        ),
        RepositoryProvider( // Provide NotesService as a repository
          create: (context) => notesService,
        ),
      ],
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
        print('AuthWrapper: Current AuthState is $state');
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthAuthenticated) {
          print('AuthWrapper: Navigating to NotesScreen.');
          // Provide NotesBloc here, only when authenticated
          return BlocProvider<NotesBloc>(
            create: (context) => NotesBloc(
              notesService: context.read<NotesService>(), // Get the NotesService instance from the tree
            )..add(const LoadNotes()), // Immediately load notes when BLoC is created
            child: const Notes(), // This should match your file name, which is 'notes.dart' and class 'Notes'
          );
        } else {
          print('AuthWrapper: Showing Login screen.');
          return const Login();
        }
      },
    );
  }
}
