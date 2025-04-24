import 'package:flutter/material.dart';
import 'package:note_tracking_app/Module/Home/Widget/add_widget.dart';
import 'package:note_tracking_app/Module/Home/Widget/home.dart';
import 'package:note_tracking_app/Module/Home/Widget/profile.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';

class NoteProvider extends ChangeNotifier {
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

  final TextEditingController listTitle = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController title = TextEditingController();

  List notes = [TextEditingController()];

  void addNote(int index) {
    notes.insert(index + 1, TextEditingController());
    notifyListeners();
  }

  bool viewMore = false;

  void descriptionShow() {
    viewMore = !viewMore;
    notifyListeners();
  }
}
