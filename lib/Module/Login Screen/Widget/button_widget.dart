import 'package:flutter/material.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';

class ButtonWidget extends StatefulWidget {
  final String text;
  const ButtonWidget({super.key, required this.text});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.button,
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      alignment: Alignment.center,
      child: TextWidget(
        color: AppColors.title,
        size: 16,
        text: widget.text,
        weight: FontWeight.bold,
      ),
    );
  }
}
