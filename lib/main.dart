import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/screens/login.dart';
import 'package:flutter_notes/screens/notes.dart';
import 'package:flutter_notes/screens/sign_up.dart';

import 'firebase_options.dart';

final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
// firestore.collection("users").doc().set({"fname": "Pretty",});
Future<void> main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Notes(),
    );
  }
}
