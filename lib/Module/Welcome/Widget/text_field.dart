import 'package:flutter/material.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';

class TextFieldWidget extends StatefulWidget {
  final String text;
  final String hint;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  const TextFieldWidget({
    super.key,
    required this.text,
    required this.hint,
    required this.controller,
    required this.validator,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: TextStyle(color: AppColors.title, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 6,
        ),
        TextFormField(
          validator: widget.validator,
          controller: widget.controller,
          cursorColor: AppColors.title,
          style: TextStyle(color: AppColors.title),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: AppColors.title,
            ),
            filled: true,
            fillColor: AppColors.textFieldBackground,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
