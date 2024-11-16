import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:main/model/todo.dart';

class ToDoDatabase extends ChangeNotifier {
  final Isar isar;

  ToDoDatabase(this.isar);

  final List<ToDo> currentToDos = [];

  Future<void> fetchToDos() async {
    final toDos = await isar.toDos.where().findAll();
    currentToDos.clear();
    currentToDos.addAll(toDos);
    notifyListeners();
  }

  Future<void> addToDo(String title) async {
    final newToDo = ToDo()..title = title;
    await isar.writeTxn(() => isar.toDos.put(newToDo));
    await fetchToDos();
  }

  Future<void> updateToDo(ToDo toDo,
      {String? newTitle, bool? isCompleted}) async {
    if (newTitle != null) toDo.title = newTitle;
    if (isCompleted != null) toDo.isCompleted = isCompleted;
    await isar.writeTxn(() => isar.toDos.put(toDo));
    await fetchToDos();
  }

  Future<void> deleteToDoById(int id) async {
    await isar.writeTxn(() => isar.toDos.delete(id));
    await fetchToDos();
  }
}
