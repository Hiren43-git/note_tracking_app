import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Database%20Service/List%20Note%20Database%20Service/list_note_database_service.dart';
import 'package:note_tracking_app/Core/Database%20Service/List%20Note%20Database%20Service/sub_list_note_database_service.dart';
import 'package:note_tracking_app/Core/Model/List%20Note%20Model/list_note_model.dart';
import 'package:note_tracking_app/Core/Model/List%20Note%20Model/sub_list_model.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';

class ListNoteProvider extends ChangeNotifier {
  final ListNoteDatabaseService listNoteDatabaseService =
      ListNoteDatabaseService();
  final SubListNoteDatabaseService subListNoteDatabaseService =
      SubListNoteDatabaseService();
  List<ListNoteModel> listNotes = [];
  List<ListNoteModel> searchNotes = [];
  List<SubListNoteModel> subListNotes = [];

  TextEditingController listTitle = TextEditingController();
  bool loading = false;

  Future<void> search(String search) async {
    if (search.isNotEmpty) {
      final result = await listNoteDatabaseService.searchResult(search);
      searchNotes = result
          .map(
            (e) => ListNoteModel.fromMap(e),
          )
          .toList();
      notifyListeners();
    }
    notifyListeners();
  }

  void clearSearch(int id) {
    loadNote(id);
    searchNotes = [];
    notifyListeners();
  }

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
    listNotes.removeWhere((element) => element.id == id);
    await listNoteDatabaseService.deleteListNote(id);
    final mainSubListNotes = subListNotes
        .where(
          (element) => element.listNoteId == id,
        )
        .toList();

    if (mainSubListNotes.isNotEmpty) {
      final newNote = mainSubListNotes.first;

      final note1 = ListNoteModel(
          userId: AuthProvider().currentUserId!,
          title: newNote.title,
          id: id,
          points: newNote.points);
      listNotes.insert(0, note1);
      subListNotes.removeWhere(
        (element) => element.id == newNote.id,
      );
      await subListNoteDatabaseService.deleteSubListNote(newNote.id!);
      await listNoteDatabaseService.addListNote(note1);
      loadNote(AuthProvider().currentUserId!);
      loadSubNote(AuthProvider().currentUserId!);
      notifyListeners();
    }
    notifyListeners();
  }

  void listDescriptionShow(int id) {
    int ids = listNotes.indexWhere(
      (element) => element.id == id,
    );
    if (ids != -1) {
      listNotes[ids].view = !listNotes[ids].view;
      notifyListeners();
    }
  }

  void subListDescriptionShow(int id) {
    int ids = subListNotes.indexWhere(
      (element) => element.id == id,
    );
    if (ids != -1) {
      subListNotes[ids].view = !subListNotes[ids].view;
      notifyListeners();
    }
  }

  List notesPointController = [TextEditingController()];

  void addNote(int index) {
    notesPointController.insert(index + 1, TextEditingController());
    notifyListeners();
  }

  Future<void> loadSubNote(int listNoteId) async {
    subListNotes = await subListNoteDatabaseService.readSubListNote(listNoteId);
    notifyListeners();
  }

  Future<void> addSubNotes(SubListNoteModel subListNote) async {
    await subListNoteDatabaseService.addSubListNote(subListNote);
    loadSubNote(subListNote.listNoteId);
    notifyListeners();
  }

  Future<void> updateSubNote(SubListNoteModel subNote) async {
    await subListNoteDatabaseService.updateSubListNote(subNote);
    loadNote(subNote.listNoteId);
    notifyListeners();
  }

  Future<void> deleteSubNote(int id) async {
    await subListNoteDatabaseService.deleteSubListNote(id);
    subListNotes.removeWhere(
      (element) => element.id == id,
    );
    notifyListeners();
  }

  int currentNoteId = 1;
  void getCurrentNoteId(int noteId) {
    currentNoteId = noteId;
    notifyListeners();
  }

  List<SubListNoteModel> getSubNotes(int listNoteId) {
    return subListNotes
        .where(
          (element) => element.listNoteId == listNoteId,
        )
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
    listTitle.dispose();
    for (var controller in notesPointController) {
      controller.dispose();
    }
  }
}
