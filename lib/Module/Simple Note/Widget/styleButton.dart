import 'package:flutter/material.dart';

Widget styleButton(
  String text,
  VoidCallback onPressed,
) {
  return GestureDetector(
    onTap: onPressed,
    child: SizedBox(
      child: Text(
        text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
    ),
  );
}