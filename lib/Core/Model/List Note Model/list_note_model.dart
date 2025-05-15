import 'dart:convert';

import 'package:flutter/material.dart';

class ListNoteModel {
  int? id;
  final int userId;
  final String title;
  final List points;
  bool view;
  String titleStyle;
  String pointsStyle;

  ListNoteModel({
    this.id,
    required this.userId,
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
      'userId': userId,
      'title': title,
      'points': points.join('|'),
      'titleStyle': titleStyle,
      'pointsStyle': pointsStyle,
    };
  }

  factory ListNoteModel.fromMap(Map m1) {
    return ListNoteModel(
      id: m1['id'],
      userId: m1['userId'],
      title: m1['title'],
      points: m1['points'].toString().split('|'),
      titleStyle: m1['titleStyle'] as String?,
      pointsStyle: m1['pointsStyle'] as String?,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ListNoteModel.fromJson(String source) =>
      ListNoteModel.fromMap(jsonDecode(source));

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
