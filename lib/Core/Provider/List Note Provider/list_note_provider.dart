import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Database%20Service/List%20Note%20Database%20Service/list_note_database_service.dart';
import 'package:note_tracking_app/Core/Model/List%20Note%20Model/list_note_model.dart';

class ListNoteProvider extends ChangeNotifier {
  final ListNoteDatabaseService listNoteDatabaseService =
      ListNoteDatabaseService();
  List<ListNoteModel> listNotes = [];

  TextEditingController listTitle = TextEditingController();

  Future<void> loadNote(int userId) async {
    listNotes = await listNoteDatabaseService.readListNote(userId);
    notifyListeners();
  }

  Future<void> addNotes(ListNoteModel listNote) async {
    await listNoteDatabaseService.addListNote(listNote);
    loadNote(listNote.userId);
    notifyListeners();
  }

  Future<void> updateNote(ListNoteModel listNote) async {
    await listNoteDatabaseService.updateListNote(listNote);
    loadNote(listNote.userId);
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    await listNoteDatabaseService.deleteListNote(id);
    listNotes.removeWhere(
      (element) => element.id == id,
    );
    notifyListeners();
  }

  List notesPointController = [TextEditingController()];

  void addNote(int index) {
    notesPointController.insert(index + 1, TextEditingController());
    notifyListeners();
  }
}
