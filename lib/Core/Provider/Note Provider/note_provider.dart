// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Database%20Service/Note%20Database%20Service/note_database_service.dart';
import 'package:note_tracking_app/Core/Database%20Service/Note%20Database%20Service/sub_note_database_service.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/note_model.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/sub_note_model.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:provider/provider.dart';

import '../../../Utils/Constant/Strings/strings.dart';
import '../Auth Provider/auth_provider.dart';

class NoteProvider extends ChangeNotifier {
  final NoteDatabaseService noteDatabaseService = NoteDatabaseService();
  final SubNoteDatabaseService subNoteDatabaseService =
      SubNoteDatabaseService();
  List<NoteModel> notes = [];
  List searchNotes = [];
  List<SubNoteModel> subNotes = [];
  bool loading = false;

  bool isLoading = false;

  Future<void> loadNote(int userId) async {
    isLoading = true;
    notes = await noteDatabaseService.readNote(userId);
    isLoading = false;
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

  Future<void> deleteNote(int id, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await noteDatabaseService.deleteNote(id);
    notes.removeWhere((element) => element.id == id);
    final mainSubNotes = subNotes
        .where(
          (element) => element.noteId == id,
        )
        .toList();
    if (mainSubNotes.isNotEmpty) {
      final newNote = mainSubNotes.first;
      final note1 = NoteModel(
        userId: authProvider.currentUserId!,
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
      loadNote(authProvider.currentUserId!);
      loadSubNote(currentNoteId);
      notifyListeners();
    } else {
      Navigator.of(context).pop();
      notifyListeners();
    }
  }

  Future<void> search(String search, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (search.isNotEmpty) {
      final result = await noteDatabaseService.searchResult(
          search, authProvider.currentUserId!);
      searchNotes = result;
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

  String field = AppStrings.title;

  NoteProvider() {
    titleFocus.addListener(
      () {
        if (titleFocus.hasFocus) {
          field = AppStrings.title;
          notifyListeners();
        }
      },
    );
    descriptionFocus.addListener(
      () {
        if (descriptionFocus.hasFocus) {
          field = AppStrings.description;
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
    if (field == AppStrings.title) {
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
    if (field == AppStrings.title) {
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
    if (field == AppStrings.title) {
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
    if (field == AppStrings.title) {
      titleStyles = titleStyles.copyWith(fontSize: 26);
    } else {
      desStyle = desStyle.copyWith(fontSize: 26);
    }
    notifyListeners();
  }

  void h2() {
    if (field == AppStrings.title) {
      titleStyles = titleStyles.copyWith(fontSize: 22);
    } else {
      desStyle = desStyle.copyWith(fontSize: 22);
    }
    notifyListeners();
  }

  void h3() {
    if (field == AppStrings.title) {
      titleStyles = titleStyles.copyWith(fontSize: 18);
    } else {
      desStyle = desStyle.copyWith(fontSize: 18);
    }
    notifyListeners();
  }

  void setColor(Color color) {
    textColor = color;
    underlineColor = color;
    if (field == AppStrings.title) {
      titleStyles = titleStyles.copyWith(color: color);
    } else {
      desStyle = desStyle.copyWith(color: color);
    }
    notifyListeners();
  }

  double viewMore = 26;

  void viewMoreSize(double size) {
    if (size == 26) {
      viewMore = 20;
    }
    if (size == 22) {
      viewMore = 17;
    }
    if (size == 18) {
      viewMore = 14;
    }
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

  List<SubNoteModel> getSubNotes(int noteId) {
    return subNotes
        .where(
          (element) => element.noteId == noteId,
        )
        .toList();
  }

  void bottomIndex(int index) {
    selectedIndexOfBottom = index;
    notifyListeners();
  }

  Future<void> addNoteInSimpleOrSubSimple(
      BuildContext context, SubNoteModel? subNote, NoteModel? note) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (title.text.isEmpty || description.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.addNoteData,
          ),
          backgroundColor: AppColors.button,
        ),
      );
    } else {
      if (subSimple == true) {
        simple = false;
        if (subNote != null) {
          final update = SubNoteModel(
            id: subNote.id,
            noteId: currentNoteId,
            title: title.text,
            description: description.text,
            titleStyle: SubNoteModel.styleToJson(titleStyles),
            descriptionStyle: SubNoteModel.styleToJson(desStyle),
          );
          await updateSubNote(update);
          clearStyle();
          await loadSubNote(currentNoteId);
        } else {
          addSubNotes(
            SubNoteModel(
              noteId: currentNoteId,
              title: title.text,
              description: description.text,
              titleStyle: SubNoteModel.styleToJson(titleStyles),
              descriptionStyle: SubNoteModel.styleToJson(desStyle),
            ),
          );
          clearStyle();
          subSimple = false;
        }
        title.clear();
        description.clear();
        await loadNote(authProvider.currentUserId!);
        Navigator.of(context).pop();
      }
      if (simple == true) {
        if (note != null) {
          final update = NoteModel(
            id: note.id,
            userId: note.userId,
            title: title.text,
            description: description.text,
            titleStyle: NoteModel.styleToJson(titleStyles),
            descriptionStyle: NoteModel.styleToJson(desStyle),
          );
          await updateNote(update);
          clearStyle();
          title.clear();
          description.clear();
        } else {
          addNotes(
            NoteModel(
              userId: authProvider.currentUserId!,
              title: title.text,
              description: description.text,
              titleStyle: NoteModel.styleToJson(titleStyles),
              descriptionStyle: NoteModel.styleToJson(desStyle),
            ),
          );
          clearStyle();
        }
        await loadNote(authProvider.currentUserId!);
        title.clear();
        description.clear();
        Navigator.of(context).pop();
      }
    }
    simple = true;
    subSimple = false;
  }
}
