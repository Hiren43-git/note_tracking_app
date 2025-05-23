import 'package:flutter/material.dart';

Map trimText(String text, TextStyle style, BuildContext context) {
  final viewMore = 'View More';
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
      'text': text,
      'exist': false,
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
        'text': testText,
        'exist': true,
      };
    }
    index--;
  }
  return {
    'text': text,
    'exist': false,
  };
}

// String trimText(String text, TextStyle style, BuildContext context) {
//   final viewMore = 'View More';
//   final width = MediaQuery.of(context).size.width - 76;
//   int index = text.length;
//   while (index > 0) {
//     final testText = text.substring(0, index).trimRight();

//     final tp = TextPainter(
//       text: TextSpan(text: '$testText $viewMore', style: style),
//       maxLines: 2,
//       textDirection: TextDirection.ltr,
//     )..layout(
//         maxWidth: width,
//       );
//     if (!tp.didExceedMaxLines) {
//       return text.substring(0, index).trimRight();
//     }
//     index--;
//   }
//   return viewMore;
// }
