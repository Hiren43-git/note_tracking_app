import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Database%20Service/Note%20Database%20Service/note_database_service.dart';
import 'package:note_tracking_app/Core/Database%20Service/Note%20Database%20Service/sub_note_database_service.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/note_model.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/sub_note_model.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';

import '../Auth Provider/auth_provider.dart';

class NoteProvider extends ChangeNotifier {
  final NoteDatabaseService noteDatabaseService = NoteDatabaseService();
  final SubNoteDatabaseService subNoteDatabaseService =
      SubNoteDatabaseService();
  List<NoteModel> notes = [];
  List<NoteModel> searchNotes = [];
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
        userId: AuthProvider().currentUserId!,
        title: newNote.title,
        id: id,
        description: newNote.description,
        descriptionStyle: newNote.descriptionStyle,
        titleStyle: newNote.titleStyle,
      );
      notes.insert(0, note1);
      subNotes.removeWhere(
        (element) => element.id == newNote.id,
      );
      await subNoteDatabaseService.deleteSubNote(newNote.id!);
      await noteDatabaseService.addNote(note1);
      loadNote(AuthProvider().currentUserId!);
      loadSubNote(currentNoteId);
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> search(String search) async {
    if (search.isNotEmpty) {
      final result = await noteDatabaseService.searchResult(search);
      searchNotes = result
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
    searchNotes = [];
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

  TextStyle titleStyles = TextStyle(
    fontSize: 26,
  );
  TextStyle desStyle = TextStyle(
    fontSize: 26,
  );

  final FocusNode titleFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();

  String field = 'title';

  NoteProvider() {
    titleFocus.addListener(
      () {
        if (titleFocus.hasFocus) {
          field = 'title';
          notifyListeners();
        }
      },
    );
    descriptionFocus.addListener(
      () {
        if (descriptionFocus.hasFocus) {
          field = 'description';
          notifyListeners();
        }
      },
    );
  }

  List colorList = [
    AppColors.text,
    AppColors.styleColor2,
    AppColors.styleColor3,
    AppColors.styleColor4,
    AppColors.styleColor5,
  ];
  Color textColor = AppColors.text;
  Color underlineColor = AppColors.text;

  void bold() {
    if (field == 'title') {
      titleStyles = titleStyles.copyWith(
        fontWeight: titleStyles.fontWeight == FontWeight.bold
            ? FontWeight.normal
            : FontWeight.bold,
      );
    } else {
      desStyle = desStyle.copyWith(
        fontWeight: desStyle.fontWeight == FontWeight.bold
            ? FontWeight.normal
            : FontWeight.bold,
      );
    }
    notifyListeners();
  }

  void italic() {
    if (field == 'title') {
      titleStyles = titleStyles.copyWith(
        fontStyle: titleStyles.fontStyle == FontStyle.italic
            ? FontStyle.normal
            : FontStyle.italic,
      );
    } else {
      desStyle = desStyle.copyWith(
        fontStyle: desStyle.fontStyle == FontStyle.italic
            ? FontStyle.normal
            : FontStyle.italic,
      );
    }
    notifyListeners();
  }

  void underline() {
    if (field == 'title') {
      titleStyles = titleStyles.copyWith(
        decoration: titleStyles.decoration == TextDecoration.underline
            ? TextDecoration.none
            : TextDecoration.underline,
        decorationColor: underlineColor,
      );
    } else {
      desStyle = desStyle.copyWith(
        decoration: desStyle.decoration == TextDecoration.underline
            ? TextDecoration.none
            : TextDecoration.underline,
        decorationColor: underlineColor,
      );
    }
    notifyListeners();
  }

  void h1() {
    if (field == 'title') {
      titleStyles = titleStyles.copyWith(fontSize: 26);
    } else {
      desStyle = desStyle.copyWith(fontSize: 26);
    }
    notifyListeners();
  }

  void h2() {
    if (field == 'title') {
      titleStyles = titleStyles.copyWith(fontSize: 22);
    } else {
      desStyle = desStyle.copyWith(fontSize: 22);
    }
    notifyListeners();
  }

  void h3() {
    if (field == 'title') {
      titleStyles = titleStyles.copyWith(fontSize: 18);
    } else {
      desStyle = desStyle.copyWith(fontSize: 18);
    }
    notifyListeners();
  }

  void setColor(Color color) {
    textColor = color;
    underlineColor = color;
    if (field == 'title') {
      titleStyles = titleStyles.copyWith(color: color);
    } else {
      desStyle = desStyle.copyWith(color: color);
    }
    notifyListeners();
  }

  void clearStyle() {
    titleStyles = TextStyle(
        fontSize: 26,
        color: AppColors.text,
        decoration: TextDecoration.none,
        decorationColor: AppColors.transparent);
    textColor = AppColors.text;
    underlineColor = AppColors.text;
    desStyle = TextStyle(
        fontSize: 26, color: AppColors.text, decoration: TextDecoration.none);
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
    loadSubNote(subNote.noteId);
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

  List currentIndex = [[]];

  List<SubNoteModel> getSubNotes(int noteId) {
    return subNotes
        .where(
          (element) => element.noteId == noteId,
        )
        .toList();
  }
}
