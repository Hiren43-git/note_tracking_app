import 'dart:convert';

import 'package:flutter/material.dart';

class SubListNoteModel {
  int? id;
  final int listNoteId;
  final String title;
  final List points;
  bool view;
  String titleStyle;
  String pointsStyle;

  SubListNoteModel({
    this.id,
    required this.listNoteId,
    required this.title,
    required this.points,
    this.view = false,
    String? titleStyle,
    String? pointsStyle,
  })  : titleStyle = titleStyle ?? styleToJson(TextStyle()),
        pointsStyle = pointsStyle ?? styleToJson(TextStyle());

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'listNoteId': listNoteId,
      'title': title,
      'points': points.join('|'),
      'titleStyle': titleStyle,
      'pointsStyle': pointsStyle,
    };
  }

  factory SubListNoteModel.fromMap(Map m1) {
    return SubListNoteModel(
      id: m1['id'],
      listNoteId: m1['listNoteId'],
      title: m1['title'],
      points: m1['points'].toString().split('|'),
      titleStyle: m1['titleStyle'] as String?,
      pointsStyle: m1['pointsStyle'] as String?,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory SubListNoteModel.fromJson(String source) =>
      SubListNoteModel.fromMap(jsonDecode(source));

  static Map<String, dynamic> styleToMap(TextStyle style) {
    final Map<String, dynamic> map = {};
    if (style.fontSize != null) {
      map['fontSize'] = style.fontSize;
    }
    if (style.fontWeight != null) {
      map['fontWeight'] =
          style.fontWeight == FontWeight.bold ? 'bold' : 'normal';
    }
    if (style.fontStyle != null) {
      map['fontStyle'] =
          style.fontStyle == FontStyle.italic ? 'italic' : 'normal';
    }
    if (style.decoration != null) {
      map['decoration'] =
          style.decoration == TextDecoration.underline ? 'underline' : 'none';
    }
    if (style.decorationColor != null) {
      map['decorationColor'] = style.color!.value;
    }
    if (style.color != null) {
      map['color'] = style.color!.value;
    }
    return map;
  }

  static String styleToJson(TextStyle style) => jsonEncode(styleToMap(style));

  static TextStyle styleFromMap(Map<String, dynamic> map) {
    return TextStyle(
      fontSize: (map['fontSize'] as num?)?.toDouble(),
      fontWeight:
          map['fontWeight'] == 'bold' ? FontWeight.bold : FontWeight.normal,
      fontStyle:
          map['fontStyle'] == 'italic' ? FontStyle.italic : FontStyle.normal,
      decoration: map['decoration'] == 'underline'
          ? TextDecoration.underline
          : TextDecoration.none,
      color: map['color'] != null ? Color(map['color']) : Colors.black,
      decorationColor:
          map['color'] != null ? Color(map['color']) : Colors.black,
    );
  }

  static TextStyle styleFromJson(String styleJson) {
    if (styleJson.isEmpty) {
      return TextStyle(fontSize: 26);
    }
    try {
      final Map<String, dynamic> map = jsonDecode(styleJson);
      return styleFromMap(map);
    } catch (e) {
      return TextStyle(fontSize: 26);
    }
  }

  static TextStyle decodeStyle(String? styleJson) {
    if (styleJson!.isEmpty) {
      return TextStyle(fontSize: 26);
    }
    try {
      final Map<String, dynamic> map = jsonDecode(styleJson);
      return TextStyle(
        fontSize: (map['fontSize'] as num?)?.toDouble(),
        fontWeight:
            map['fontWeight'] == 'bold' ? FontWeight.bold : FontWeight.normal,
        fontStyle:
            map['fontStyle'] == 'italic' ? FontStyle.italic : FontStyle.normal,
        decoration: map['decoration'] == 'underline'
            ? TextDecoration.underline
            : TextDecoration.none,
        color: map['color'] != null ? Color(map['color']) : Colors.black,
        decorationColor:
            map['decorationColor'] != null ? Color(map['color']) : Colors.black,
      );
    } catch (e) {
      return TextStyle(fontSize: 26);
    }
  }

  TextStyle get titleStyles => decodeStyle(titleStyle);
  TextStyle get pointStyle => decodeStyle(pointsStyle);
}
