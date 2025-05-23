import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Database%20Service/Note%20Database%20Service/note_database_service.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/note_model.dart';
import 'package:note_tracking_app/Module/Home/Widget/add_widget.dart';
import 'package:note_tracking_app/Module/Home/Widget/home.dart';
import 'package:note_tracking_app/Module/Home/Widget/profile.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';

class NoteProvider extends ChangeNotifier {
  final NoteDatabaseService noteDatabaseService = NoteDatabaseService();
  List<NoteModel> notes = [];

  Future<void> loadNote(int userId) async {
    notes = await noteDatabaseService.readNote(userId);
    notifyListeners();
  }

  Future<void> addNotes(NoteModel note) async {
    await noteDatabaseService.addNote(note);
    notifyListeners();
    loadNote(note.userId);
  }

  Future<void> updateNote(NoteModel note) async {
    await noteDatabaseService.updateNote(note);
    loadNote(note.userId);
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    await noteDatabaseService.deleteNote(id);
    notifyListeners();
  }

  int selectedIndexOfBottom = 0;

  bool simple = false;
  bool list = false;
  final List colors = [
    AppColors.cardColor,
    AppColors.cardColor2,
    AppColors.cardColor3,
    AppColors.cardColor4,
    AppColors.cardColor5,
  ];

  final List screen = [
    HomeWidget(),
    AddWidget(),
    ProfileWidget(),
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

  TextEditingController listTitle = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController title = TextEditingController();

  List notesController = [TextEditingController()];

  void addNote(int index) {
    notesController.insert(index + 1, TextEditingController());
    notifyListeners();
  }

  bool viewMore = false;

  void descriptionShow() {
    viewMore = !viewMore;
    notifyListeners();
  }
}
