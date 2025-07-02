import 'package:flutter/material.dart';
import 'package:flutter_notes/screens/login.dart';
import 'package:flutter_notes/screens/notes.dart';
import 'package:flutter_notes/screens/sign_up.dart';

import 'firebase_options.dart';

Future<void> main() async {
  runApp(const MyApp());
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
