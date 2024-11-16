import 'package:flutter/material.dart';
import 'package:main/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:main/screens/login_screen.dart';
import 'package:main/model/note_database.dart';
import 'package:main/model/todo_database.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:main/model/note.dart';
import 'package:main/model/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();

  // Open a single Isar instance for both schemas
  final isar = await Isar.open([NoteSchema, ToDoSchema], directory: dir.path);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NoteDatabase(isar),
        ), // Pass the shared instance
        ChangeNotifierProvider(
          create: (context) => ToDoDatabase(isar),
        ), // Pass the shared instance
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: context.watch<ThemeProvider>().themeData,
    );
  }
}
