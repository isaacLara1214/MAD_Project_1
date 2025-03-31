import 'package:flutter/material.dart';
import 'package:mindfulmoments/repo/notesrepo.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notes = [];

  NotesProvider() {
    getNotes(); // Load notes when the provider is created
  }

  getNotes() async {
    notes = await Notesrepo.getNotes();
    notifyListeners();
  }

  insert({required Note note}) async {
    await Notesrepo.insert(note: note);
    getNotes();
  }

  update({required Note note}) async {
    await Notesrepo.update(note: note);
    getNotes();
  }

  delete({required Note note}) async {
    await Notesrepo.delete(note: note);
    getNotes();
  }
}
