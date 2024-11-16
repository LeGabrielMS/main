import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main/components/drawer.dart';
import 'package:main/components/note_tile.dart';
import 'package:main/model/note.dart';
import 'package:main/model/note_database.dart';
import 'package:provider/provider.dart';
import 'package:main/themes/theme.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  // Create a note
  void createNote() {
    textController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: 'Write something...',
            hintStyle: TextStyle(color: tdGrey),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Note cannot be empty!")),
                );
                return;
              }
              context.read<NoteDatabase>().addNote(textController.text);
              textController.clear();
              Navigator.pop(context);

              // Show snackbar for successful note creation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Note added successfully!")),
              );
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  // Read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // Update a note
  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Update Note'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Enter new text"),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Updated text cannot be empty!")),
                );
                return;
              }
              context
                  .read<NoteDatabase>()
                  .updateNote(note, textController.text);
              textController.clear();
              Navigator.pop(context);

              // Show snackbar for successful note update
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Note updated successfully!")),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // Delete a note
  void deleteNoteById(int id) {
    context.read<NoteDatabase>().deleteNoteById(id);

    // Show snackbar for successful note deletion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Note deleted successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(Icons.add),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                final note = currentNotes[index];
                return NoteTile(
                  text: note.text,
                  onEditPressed: () => updateNote(note),
                  onDeletePressed: () => deleteNoteById(note.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
