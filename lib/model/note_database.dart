import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:main/model/note.dart';

class NoteDatabase extends ChangeNotifier {
  final Isar isar;

  NoteDatabase(this.isar);

  final List<Note> currentNotes = [];

  Future<void> addNote(String textFromUser) async {
    final newNote = Note()..text = textFromUser;
    await isar.writeTxn(() => isar.notes.put(newNote));
    await fetchNotes(); // Refresh the in-memory list
    notifyListeners(); // Notify UI about the change
  }

  Future<void> updateNote(Note note, String newText) async {
    note.text = newText;
    await isar.writeTxn(() => isar.notes.put(note));
    await fetchNotes(); // Refresh the in-memory list
    notifyListeners(); // Notify UI about the change
  }

  Future<void> deleteNoteById(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes(); // Refresh the in-memory list
    notifyListeners(); // Notify UI about the change
  }

  Future<void> fetchNotes() async {
    final notes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(notes);
    notifyListeners(); // Notify the UI about changes
  }
}
