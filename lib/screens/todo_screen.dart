import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main/components/drawer.dart';
import 'package:main/components/profile_icon.dart';
import 'package:main/model/todo.dart';
import 'package:main/model/todo_database.dart';
import 'package:main/themes/theme.dart';
import 'package:provider/provider.dart';
import 'package:main/components/todo_tile.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final textController = TextEditingController();

  // New controller for search functionality
  final searchController = TextEditingController();

  // Lists to hold all to-dos and filtered to-dos
  List<ToDo> allToDos = [];
  List<ToDo> filteredToDos = [];

  @override
  void initState() {
    super.initState();
    _refreshToDos();
  }

  @override
  void dispose() {
    textController.dispose();
    searchController.dispose();
    super.dispose();
  }

  // Refresh all to-dos and initialize lists
  Future<void> _refreshToDos() async {
    final toDoDatabase = context.read<ToDoDatabase>();
    await toDoDatabase.fetchToDos(); // Fetch to-dos from the database
    if (mounted) {
      setState(() {
        allToDos = toDoDatabase.currentToDos;
        filteredToDos = allToDos; // Initialize filtered list
      });
    }
  }

  // Method to filter to-dos based on search query
  void _filterToDos(String query) {
    setState(() {
      filteredToDos = allToDos.where((toDo) {
        // Check if the to-do title contains the query, case insensitive
        return toDo.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // Add a new to-do
  void _addToDo() {
    textController.clear();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: 'Enter new to-do...',
            hintStyle: TextStyle(color: tdGrey),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              if (textController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("To-Do cannot be empty!"),
                  ),
                );
                return;
              }

              // Capture Navigator before async operation
              final navigator = Navigator.of(dialogContext);

              // Use local reference to ToDoDatabase
              final toDoDatabase = context.read<ToDoDatabase>();
              await toDoDatabase.addToDo(textController.text);

              // Clear controller and close dialog
              textController.clear();
              navigator.pop(); // Use captured Navigator

              // Safely refresh UI and reset search
              _refreshToDos();
              searchController.clear();
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // Edit an existing to-do
  void _editToDo(ToDo toDo) {
    textController.text = toDo.title;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Edit To-Do"),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: "Update to-do title",
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

              // Capture Navigator before async operation
              final navigator = Navigator.of(dialogContext);

              // Use local reference to ToDoDatabase
              final toDoDatabase = context.read<ToDoDatabase>();
              await toDoDatabase.updateToDo(toDo,
                  newTitle: textController.text);

              // Clear controller and close dialog
              textController.clear();
              navigator.pop(); // Use captured Navigator

              // Safely refresh UI and reset search
              _refreshToDos();
              searchController.clear();
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // Delete a to-do by ID
  void _deleteToDoById(int id) async {
    final toDoDatabase =
        context.read<ToDoDatabase>(); // Capture the database synchronously
    final scaffoldMessenger = ScaffoldMessenger.of(
        context); // Capture ScaffoldMessenger synchronously

    await toDoDatabase.deleteToDoById(id);

    // Safely refresh UI
    if (mounted) {
      setState(() {
        _refreshToDos();
      });
      // Use the captured ScaffoldMessenger to show the SnackBar
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text("To-Do deleted successfully!")),
      );
    }
  }

  void _toggleCompletion(ToDo toDo, bool? isCompleted) async {
    if (isCompleted == null) return;

    final toDoDatabase = context.read<ToDoDatabase>();
    await toDoDatabase.updateToDo(toDo, isCompleted: isCompleted);

    // Refresh the list while retaining the search filter
    if (mounted) {
      setState(() {
        toDo.isCompleted = isCompleted; // Update local object
        _filterToDos(searchController.text); // Retain filtered list
      });
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
        onPressed: _addToDo,
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
              'To-Do List',
              style: GoogleFonts.dmSerifText(
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: _filterToDos,
              decoration: InputDecoration(
                hintText: 'Search to-dos...',
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
          Expanded(
            child: ListView.builder(
              itemCount: filteredToDos.length,
              itemBuilder: (context, index) {
                final toDo = filteredToDos[index];
                return ToDoTile(
                  toDo: toDo,
                  onCompletedChanged: (value) => _toggleCompletion(toDo, value),
                  onEditPressed: () => _editToDo(toDo),
                  onDeletePressed: () => _deleteToDoById(toDo.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
