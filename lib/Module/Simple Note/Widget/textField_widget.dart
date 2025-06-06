import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/List%20Note%20Provider/list_note_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';

class TextFieldWidget extends StatefulWidget {
  final NoteProvider? provider;
  final ListNoteProvider? listProvider;
  final TextEditingController controller;
  final String? hintText;
  final int? line;
  final FocusNode? focusNode;
  final TextStyle? style;
  final ValueChanged? onSubmit;

  const TextFieldWidget({
    super.key,
    required this.controller,
    this.provider,
    this.listProvider,
    this.hintText,
    this.style,
    this.focusNode,
    this.line,
    this.onSubmit,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: widget.onSubmit,
      autocorrect: false,
      focusNode: widget.focusNode,
      maxLines: widget.line,
      controller: widget.controller,
      style: widget.style,
      cursorColor: AppColors.text,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: AppColors.divider,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}