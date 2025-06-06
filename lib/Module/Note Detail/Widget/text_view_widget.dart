import 'package:flutter/material.dart';

import '../../../Utils/Constant/Strings/strings.dart';

Map trimText(String text, TextStyle style, BuildContext context) {
  final viewMore = AppStrings.viewMore;
  final width = MediaQuery.of(context).size.width - 76;
  int index = text.length;

  final full = TextPainter(
    text: TextSpan(text: '$text $viewMore', style: style),
    maxLines: 2,
    textDirection: TextDirection.ltr,
  )..layout(
      maxWidth: width,
    );

  if (!full.didExceedMaxLines) {
    return {
      AppStrings.text: text,
      AppStrings.exist: false,
    };
  }

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
      return {
        AppStrings.text: testText,
        AppStrings.exist: true,
      };
    }
    index--;
  }
  return {
    'text': text,
    'exist': false,
  };
}
