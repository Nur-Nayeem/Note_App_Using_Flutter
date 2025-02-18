import 'package:flutter/material.dart';
import 'package:note_app_with_flutter/NoteDatabase/note_database.dart';
import 'package:note_app_with_flutter/Screen/note_card.dart';
import 'package:note_app_with_flutter/Screen/note_dialog.dart';
import 'package:note_app_with_flutter/Screen/note_view.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await NoteDatabase.instance.getNotes();

    setState(() {
      notes = fetchedNotes;
    });
  }

  final List<Color> noteColors = [
    const Color(0xFFF3E5F5), // Light Purple
    const Color(0xFFFFEFD5), // Light Orange
    const Color(0xFFB1E1FF), // Light Blue
    const Color(0xFFFCE4EC), // Light Pink
    const Color(0xFFB9F9FC), // Baby Blue
    const Color(0xFFFFABAB), // Light Red
    const Color(0xFFB2F9FC), // Light Cyan
    const Color(0xFFFFD59A), // Light Peach
    const Color(0xFFFFE4B5), // Moccasin
    const Color(0xFF98FB98), // Pale Green
    const Color(0xFFF7D700), // Gold
    const Color(0xFFAFEEEE), // Pale Turquoise
    const Color(0xFFFFB6C1), // Light Pink
    const Color(0xFFFAFAD2), // Light Goldenrod Yellow
    const Color(0xFFD3D3D3), // Light Grey
  ];

  void showNoteDialog({
    int? id,
    String? title,
    String? content,
    int colorIndex = 0,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return NoteDialog(
          colorIndex: colorIndex,
          noteColors: noteColors,
          noteId: id,
          title: title,
          content: content,
          // Inside the onNoteSaved callback within showNoteDialog
          onNoteSaved: (
            newTitle,
            newDescription,
            selectedColorIndex,
            currentDate,
          ) async {
            if (id == null) {
              // Corrected parameter order: date comes before color
              await NoteDatabase.instance.addNote(
                newTitle,
                newDescription,
                currentDate,
                selectedColorIndex,
              ); // Fixed here
            } else {
              await NoteDatabase.instance.updateNote(
                newTitle,
                newDescription,
                currentDate,
                selectedColorIndex,
                id,
              );
            }
            fetchNotes(); // Ensure notes are refreshed after saving
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Notes",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoteDialog();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black87),
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notes_outlined,
                    size: 80,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    " No Notes Found",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NoteCard(
                    note: note,
                    onEdit: () async {
                      showNoteDialog(
                        id: note['id'],
                        title: note['title'],
                        content: note['description'],
                        colorIndex: note['color'],
                      );
                    },
                    onDelete: () async {
                      await NoteDatabase.instance.deleteNote(note['id']);
                      fetchNotes();
                    },
                    onTap: () async {
                      // Navigate to the NoteView screen
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteView(
                            id: note['id'],
                            title: note['title'],
                            content: note['description'],
                            colorIndex: note['color'],
                            noteColors: noteColors,
                          ),
                        ),
                      );
                    },
                    noteColors: noteColors,
                  );
                },
              ),
            ),
    );
  }
}
