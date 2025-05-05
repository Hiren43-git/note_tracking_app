class SubListNoteModel {
  int? id;
  final int listNoteId;
  final String title;
  final List points;
  bool view;
  SubListNoteModel({
    this.id,
    required this.listNoteId,
    required this.title,
    required this.points,
    this.view = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'listNoteId': listNoteId,
      'title': title,
      'points': points.join('|'),
    };
  }

  factory SubListNoteModel.fromMap(Map m1) {
    return SubListNoteModel(
      id: m1['id'],
      listNoteId: m1['listNoteId'],
      title: m1['title'],
      points: m1['points'].toString().split('|'),
    );
  }
}
