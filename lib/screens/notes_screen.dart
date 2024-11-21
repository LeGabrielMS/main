import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main/components/drawer.dart';
import 'package:main/components/note_tile.dart';
import 'package:main/components/profile_icon.dart';
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
  final searchController = TextEditingController();

  List<Note> allNotes = [];
  List<Note> filteredNotes = [];

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  @override
  void dispose() {
    textController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshNotes() async {
    final noteDatabase = context.read<NoteDatabase>();
    await noteDatabase.fetchNotes();
    if (mounted) {
      setState(() {
        allNotes = noteDatabase.currentNotes;
        filteredNotes = allNotes; // Retain search results
      });
    }
  }

  void _filterNotes(String query) {
    setState(() {
      filteredNotes = allNotes.where((note) {
        return note.text.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _createNote() {
    textController.clear();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () async {
              if (textController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Note cannot be empty!"),
                  ),
                );
                return;
              }

              final navigator = Navigator.of(dialogContext);
              final noteDatabase = context.read<NoteDatabase>();
              await noteDatabase.addNote(textController.text);

              textController.clear();
              navigator.pop();
              _refreshNotes();
              searchController.clear();
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  void _updateNote(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Update Note'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: "Enter new text",
            hintStyle: TextStyle(color: tdGrey),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              if (textController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Updated text cannot be empty!"),
                  ),
                );
                return;
              }

              final navigator = Navigator.of(dialogContext);
              final noteDatabase = context.read<NoteDatabase>();
              await noteDatabase.updateNote(note, textController.text);

              textController.clear();
              navigator.pop();
              _refreshNotes();
              searchController.clear();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteNoteById(int id) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final noteDatabase = context.read<NoteDatabase>();
    await noteDatabase.deleteNoteById(id);

    if (mounted) {
      setState(() {
        allNotes.removeWhere((note) => note.id == id);
        _filterNotes(searchController.text); // Retain filtered state
      });

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text("Note deleted successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: ProfileIcon(),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: _createNote,
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

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: _filterNotes,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                hintStyle: TextStyle(color: tdGrey),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Display filtered to-dos
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                return NoteTile(
                  text: note.text,
                  onEditPressed: () => _updateNote(note),
                  onDeletePressed: () => _deleteNoteById(note.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
