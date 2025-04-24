
import 'package:flutter/material.dart';

class TextWidget extends StatefulWidget {
  final double size;
  final String text;
  final Color color;
  final TextOverflow? overflow;
  final int? line;
  final FontWeight? weight;
  const TextWidget(
      {super.key,
      required this.color,
      required this.size,
      required this.text,
      this.weight,
      this.overflow,
      this.line});

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
          color: widget.color,
          fontWeight: widget.weight,
          fontSize: widget.size,
          overflow: widget.overflow),
      maxLines: widget.line,
    );
  }
}
