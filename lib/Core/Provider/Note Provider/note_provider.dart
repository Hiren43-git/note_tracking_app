import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Database%20Service/Note%20Database%20Service/note_database_service.dart';
import 'package:note_tracking_app/Core/Database%20Service/Note%20Database%20Service/sub_note_database_service.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/note_model.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/sub_note_model.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';

class NoteProvider extends ChangeNotifier {
  final NoteDatabaseService noteDatabaseService = NoteDatabaseService();
  final SubNoteDatabaseService subNoteDatabaseService =
      SubNoteDatabaseService();
  List<NoteModel> notes = [];
  List<SubNoteModel> subNotes = [];
  bool loading = false;

  Future<void> loadNote(int userId) async {
    notes = await noteDatabaseService.readNote(userId);
    notifyListeners();
  }

  Future<void> addNotes(NoteModel note) async {
    await noteDatabaseService.addNote(note);
    loadNote(note.userId);
    notifyListeners();
  }

  Future<void> updateNote(NoteModel note) async {
    await noteDatabaseService.updateNote(note);
    loadNote(note.userId);
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    notes.removeWhere((element) => element.id == id);
    await noteDatabaseService.deleteNote(id);
    final mainSubNotes = subNotes
        .where(
          (element) => element.noteId == id,
        )
        .toList();

    if (mainSubNotes.isNotEmpty) {
      final newNote = mainSubNotes.first;

      final note1 = NoteModel(
        userId: AuthProvider().currentUserId,
        title: newNote.title,
        id: id,
        description: newNote.description,
      );
      notes.insert(0, note1);
      subNotes.removeWhere(
        (element) => element.id == newNote.id,
      );
      await subNoteDatabaseService.deleteSubNote(newNote.id!);
      await noteDatabaseService.addNote(note1);
      loadNote(AuthProvider().currentUserId);
      loadSubNote(AuthProvider().currentUserId);
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> search(String search) async {
    if (search.isNotEmpty) {
      final result = await noteDatabaseService.searchResult(search);
      notes = result
          .map(
            (e) => NoteModel.fromMap(e),
          )
          .toList();
      notifyListeners();
    }
    notifyListeners();
  }

  void clearSearch(int id) {
    loadNote(id);
    notifyListeners();
  }

  int selectedIndexOfBottom = 0;

  bool simple = false;
  bool list = false;
  bool subSimple = false;
  bool subList = false;

  final List colors = [
    AppColors.cardColor,
    AppColors.cardColor2,
    AppColors.cardColor3,
    AppColors.cardColor4,
    AppColors.cardColor5,
  ];

  bool edit = false;

  TextStyle textStyle = TextStyle(
    fontSize: 24,
  );
  Color textColor = AppColors.text;

  void style(TextStyle style) {
    textStyle = textStyle.merge(style);
    notifyListeners();
  }

  void changeColor(Color color) {
    textColor = color;
    notifyListeners();
  }

  TextEditingController description = TextEditingController();
  TextEditingController title = TextEditingController();

  void descriptionShow(int id) {
    int ids = notes.indexWhere(
      (element) => element.id == id,
    );
    if (ids != -1) {
      notes[ids].view = !notes[ids].view;
    }
    notifyListeners();
  }

  void subDescriptionShow(int id) {
    int ids = subNotes.indexWhere(
      (element) => element.id == id,
    );
    if (ids != -1) {
      subNotes[ids].view = !subNotes[ids].view;
      notifyListeners();
    }
  }

  Future<void> loadSubNote(int noteId) async {
    subNotes = await subNoteDatabaseService.readSubNote(noteId);
    notifyListeners();
  }

  Future<void> addSubNotes(SubNoteModel subNote) async {
    await subNoteDatabaseService.addSubNote(subNote);
    loadSubNote(subNote.noteId);
    notifyListeners();
  }

  Future<void> updateSubNote(SubNoteModel subNote) async {
    await subNoteDatabaseService.updateSubNote(subNote);
    loadNote(subNote.noteId);
    notifyListeners();
  }

  Future<void> deleteSubNote(int id) async {
    await subNoteDatabaseService.deleteSubNote(id);
    subNotes.removeWhere(
      (element) => element.id == id,
    );
    notifyListeners();
  }

  int currentNoteId = 1;
  void getCurrentNoteId(int noteId) {
    currentNoteId = noteId;
    notifyListeners();
  }

  List<SubNoteModel> getSubNotes(int noteId) {
    return subNotes
        .where(
          (element) => element.noteId == noteId,
        )
        .toList();
  }
}