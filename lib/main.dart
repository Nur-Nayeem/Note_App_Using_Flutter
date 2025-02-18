import 'package:flutter/material.dart';
import 'package:note_app_with_flutter/Screen/note_screen.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Note App",
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const NoteScreen(),
    );
  }
}
