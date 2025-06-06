// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Database%20Service/List%20Note%20Database%20Service/list_note_database_service.dart';
import 'package:note_tracking_app/Core/Database%20Service/List%20Note%20Database%20Service/sub_list_note_database_service.dart';
import 'package:note_tracking_app/Core/Model/List%20Note%20Model/list_note_model.dart';
import 'package:note_tracking_app/Core/Model/List%20Note%20Model/sub_list_model.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

class ListNoteProvider extends ChangeNotifier {
  final ListNoteDatabaseService listNoteDatabaseService =
      ListNoteDatabaseService();
  final SubListNoteDatabaseService subListNoteDatabaseService =
      SubListNoteDatabaseService();

  List<ListNoteModel> listNotes = [];
  List searchNotes = [];
  List<SubListNoteModel> subListNotes = [];

  TextEditingController listTitle = TextEditingController();
  bool loading = false;

  Future<void> search(String search, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (search.isNotEmpty) {
      final result = await listNoteDatabaseService.searchResult(
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

  Future<void> deleteNote(int id, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
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
        userId: authProvider.currentUserId!,
        title: newNote.title,
        id: id,
        points: newNote.points,
        titleStyle: newNote.titleStyle,
        pointsStyle: newNote.pointsStyle,
      );
      listNotes.insert(0, note1);
      subListNotes.removeWhere(
        (element) => element.id == newNote.id,
      );
      await subListNoteDatabaseService.deleteSubListNote(newNote.id!);
      await listNoteDatabaseService.addListNote(note1);
      loadNote(authProvider.currentUserId!);
      loadSubNote(currentNoteId);
      notifyListeners();
    } else {
      Navigator.of(context).pop();
      notifyListeners();
    }
  }

  TextStyle titleStyles = TextStyle(
    fontSize: 26,
  );
  TextStyle pointStyle = TextStyle(
    fontSize: 26,
  );

  final FocusNode titleFocus = FocusNode();
  List pointFocus = [FocusNode()];
  List notesPointController = [TextEditingController()];

  void addPoint(int index, BuildContext context) {
    final empty = notesPointController.any(
      (element) => element.text.isEmpty,
    );
    if (empty) {
      return;
    }
    while (notesPointController.length <= index + 1) {
      notesPointController.add(TextEditingController());
    }
    while (pointFocus.length <= index + 1) {
      pointFocus.add(FocusNode());
    }
    notifyListeners();

    Future.delayed(Duration(milliseconds: 120), () {
      if (index + 1 < pointFocus.length) {
        FocusScope.of(context).requestFocus(
          pointFocus[index + 1],
        );
      }
    });
  }

  bool call = false;
  void addFirstPoint() {
    call = true;
    notesPointController.insert(0, TextEditingController());
    pointFocus.insert(0, FocusNode());
    notifyListeners();
  }

  void removePoint(int index) {
    if (index >= 0 && index < pointFocus.length) {
      pointFocus[index].dispose();
      notesPointController[index].dispose();
      pointFocus.removeAt(index);
      notesPointController.removeAt(index);
      notifyListeners();
    }
  }

  ListNoteProvider() {
    titleFocus.addListener(
      () {
        if (titleFocus.hasFocus) {
          field = AppStrings.title;
          notifyListeners();
        } else {
          field = AppStrings.point;
          notifyListeners();
        }
      },
    );
  }
  void disposePoint() {
    for (var node in pointFocus) {
      node.dispose();
    }
    for (var controller in notesPointController) {
      controller.dispose();
    }
    pointFocus.clear();
    notesPointController.clear();
  }

  String field = AppStrings.title;
  Color textColor = AppColors.text;
  Color pointColor = AppColors.text;
  Color underlineColor = AppColors.text;

  void bold() {
    if (field == AppStrings.title) {
      titleStyles = titleStyles.copyWith(
        fontWeight: titleStyles.fontWeight == FontWeight.bold
            ? FontWeight.normal
            : FontWeight.bold,
      );
    } else {
      pointStyle = pointStyle.copyWith(
        fontWeight: pointStyle.fontWeight == FontWeight.bold
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
      pointStyle = pointStyle.copyWith(
        fontStyle: pointStyle.fontStyle == FontStyle.italic
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
      pointStyle = pointStyle.copyWith(
        decoration: pointStyle.decoration == TextDecoration.underline
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
      pointStyle = pointStyle.copyWith(fontSize: 26);
    }
    notifyListeners();
  }

  void h2() {
    if (field == AppStrings.title) {
      titleStyles = titleStyles.copyWith(fontSize: 22);
    } else {
      pointStyle = pointStyle.copyWith(fontSize: 22);
    }
    notifyListeners();
  }

  void h3() {
    if (field == AppStrings.title) {
      titleStyles = titleStyles.copyWith(fontSize: 18);
    } else {
      pointStyle = pointStyle.copyWith(fontSize: 18);
    }
    notifyListeners();
  }

  void setColor(Color color) {
    textColor = color;
    underlineColor = color;
    if (field == AppStrings.title) {
      titleStyles = titleStyles.copyWith(color: color);
    } else {
      pointColor = color;
      pointStyle = pointStyle.copyWith(color: color);
      notifyListeners();
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
    pointColor = AppColors.text;
    underlineColor = AppColors.text;
    pointStyle = TextStyle(
        fontSize: 26, color: AppColors.text, decoration: TextDecoration.none);
    field = AppStrings.title;
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
    loadSubNote(currentNoteId);
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

  void temp() {
    notifyListeners();
  }

  void tempField(String tempField) {
    field = tempField;
  }

  void tempPoint() {
    field = AppStrings.point;
  }

  Future<void> addNoteInListNoteOrSubListNote(BuildContext context,
      SubListNoteModel? subListNote, ListNoteModel? listNote) async {
    final provider = Provider.of<NoteProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (listTitle.text.isEmpty || notesPointController[0].text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.addNoteData,
          ),
          backgroundColor: AppColors.button,
        ),
      );
    } else {
      if (provider.subList == true) {
        provider.list = false;
        if (subListNote != null) {
          final temp = notesPointController
              .map(
                (e) => e.text,
              )
              .where(
                (element) => element.isNotEmpty,
              )
              .toList();
          final update = SubListNoteModel(
            id: subListNote.id,
            listNoteId: currentNoteId,
            title: listTitle.text,
            points: temp,
            titleStyle: ListNoteModel.styleToJson(titleStyles),
            pointsStyle: ListNoteModel.styleToJson(pointStyle),
          );
          await updateSubNote(update);
          clearStyle();
          for (int i = 0; i < notesPointController.length; i++) {
            notesPointController[i];
            clearStyle();
          }
          await loadSubNote(currentNoteId);
        } else {
          final temp = notesPointController
              .map(
                (e) => e.text,
              )
              .where(
                (element) => element.isNotEmpty,
              )
              .toList();
          addSubNotes(
            SubListNoteModel(
              listNoteId: currentNoteId,
              title: listTitle.text,
              points: temp,
              titleStyle: ListNoteModel.styleToJson(titleStyles),
              pointsStyle: ListNoteModel.styleToJson(pointStyle),
            ),
          );
          clearStyle();
          for (int i = 0; i < notesPointController.length; i++) {
            notesPointController[i];
            clearStyle();
          }
          provider.subList = false;
        }
        listTitle.clear();
        notesPointController.clear();
        pointFocus.clear();
        await loadNote(authProvider.currentUserId!);
        Navigator.of(context).pop();
      }
      if (provider.list == true) {
        if (listNote != null) {
          final temp = notesPointController
              .map(
                (e) => e.text,
              )
              .where(
                (element) => element.isNotEmpty,
              )
              .toList();
          final update = ListNoteModel(
            id: listNote.id,
            userId: listNote.userId,
            title: listTitle.text,
            points: temp,
            titleStyle: ListNoteModel.styleToJson(titleStyles),
            pointsStyle: ListNoteModel.styleToJson(pointStyle),
          );
          await updateNote(update);
          clearStyle();
          for (int i = 0; i < notesPointController.length; i++) {
            notesPointController[i];
            clearStyle();
          }
        } else {
          final temp = notesPointController
              .map(
                (e) => e.text,
              )
              .where(
                (element) => element.isNotEmpty,
              )
              .toList();
          addNotes(
            ListNoteModel(
              userId: authProvider.currentUserId!,
              title: listTitle.text,
              points: temp,
              titleStyle: ListNoteModel.styleToJson(titleStyles),
              pointsStyle: ListNoteModel.styleToJson(pointStyle),
            ),
          );
          clearStyle();
          for (int i = 0; i < notesPointController.length; i++) {
            notesPointController[i];
            clearStyle();
          }
        }
        await loadNote(authProvider.currentUserId!);
        listTitle.clear();
        notesPointController.clear();
        pointFocus.clear();
        Navigator.of(context).pop();
      }
    }
    provider.list = true;
    provider.subList = false;
  }
}
