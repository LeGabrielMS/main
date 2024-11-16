import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:main/model/note.dart';

class NoteDatabase extends ChangeNotifier {
  final Isar isar;

  NoteDatabase(this.isar);

  final List<Note> currentNotes = [];

  Future<void> fetchNotes() async {
    final notes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(notes);
    notifyListeners();
  }

  Future<void> addNote(String text) async {
    final newNote = Note()..text = text;
    await isar.writeTxn(() => isar.notes.put(newNote));
    await fetchNotes();
  }

  Future<void> updateNote(Note note, String newText) async {
    note.text = newText;
    await isar.writeTxn(() => isar.notes.put(note));
    await fetchNotes();
  }

  Future<void> deleteNoteById(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
