import 'package:flutter/material.dart';

String trimText(String text, TextStyle style, BuildContext context) {
  final viewMore = '...ViewMore';
  final width = MediaQuery.of(context).size.width - 76;
  int index = text.length;
  while (index > 0) {
    final testText = text.substring(0, index).trimRight();

    final tp = TextPainter(
      text: TextSpan(text: '$testText $viewMore', style: style),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth: width,
      );
    if (!tp.didExceedMaxLines) {
      return text.substring(0, index).trimRight();
    }
    index--;
  }
  return viewMore;
}
