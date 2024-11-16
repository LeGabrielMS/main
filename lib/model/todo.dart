import 'package:isar/isar.dart';

part 'todo.g.dart';

@collection
class ToDo {
  Id id = Isar.autoIncrement; // Unique ID

  late String title;
  bool isCompleted = false; // Status of the to-do item
}
