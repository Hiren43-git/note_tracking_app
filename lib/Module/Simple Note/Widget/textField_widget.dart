import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/List%20Note%20Provider/list_note_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';

TextField textField(NoteProvider provider, TextEditingController controller,
    double height, String hintText, double size) {
  return TextField(
    controller: controller,
    style: provider.textStyle.copyWith(
        color: provider.textColor, decorationColor: provider.textColor),
    cursorHeight: height,
    cursorColor: AppColors.text,
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.divider,
        fontWeight: FontWeight.w500,
        fontSize: size,
      ),
    ),
  );
}

TextField listTextField(
    NoteProvider? provider,
    ListNoteProvider listProvider,
    TextEditingController controller,
    double height,
    String hintText,
    double size) {
  return TextField(
    controller: controller,
    style: provider!.textStyle.copyWith(
        color: provider.textColor, decorationColor: provider.textColor),
    cursorHeight: height,
    cursorColor: AppColors.text,
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.divider,
        fontWeight: FontWeight.w500,
        fontSize: size,
      ),
    ),
  );
}
