import 'package:flutter/material.dart';

class NoteView extends StatefulWidget {
  final int id;
  final String title;
  final String content;
  final int colorIndex;
  final List<Color> noteColors;

  const NoteView({
    Key? key,
    required this.id,
    required this.title,
    required this.content,
    required this.colorIndex,
    required this.noteColors,
  }) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    // Define a list of colors to choose from based on the colorIndex
    final Size screenSize = MediaQuery.of(context).size;
    // Ensure the colorIndex is within bounds
    final Color noteColor =
        widget.noteColors[widget.colorIndex % widget.noteColors.length];

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: noteColor),
      body: Container(
        width: screenSize.width, // Set the width to the screen width
        height: screenSize.height,
        color: noteColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(widget.content, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
