import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main/components/drawer.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ToDoDatabase>().fetchToDos();
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _addToDo() {
    textController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: 'Enter new to-do...',
            hintStyle: TextStyle(color: tdGrey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("To-Do cannot be empty!")),
                );
                return;
              }
              context.read<ToDoDatabase>().addToDo(textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _editToDo(ToDo toDo) {
    textController.text = toDo.title;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
          TextButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Updated text cannot be empty!")),
                );
                return;
              }
              context
                  .read<ToDoDatabase>()
                  .updateToDo(toDo, newTitle: textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _deleteToDoById(int id) {
    context.read<ToDoDatabase>().deleteToDoById(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("To-Do deleted successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final toDoDatabase = context.watch<ToDoDatabase>();
    final toDoList = toDoDatabase.currentToDos;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
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
          Expanded(
            child: ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (context, index) {
                final toDo = toDoList[index];
                return ToDoTile(
                  toDo: toDo,
                  onCompletedChanged: (value) => context
                      .read<ToDoDatabase>()
                      .updateToDo(toDo, isCompleted: value ?? false),
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
