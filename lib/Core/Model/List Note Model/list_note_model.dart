class ListNoteModel {
  int? id;
  final int userId;
  final String title;
  final List points;
  bool view;

  ListNoteModel({
    this.id,
    required this.userId,
    required this.title,
    required this.points,
    this.view = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'points': points.join('|'),
    };
  }

  factory ListNoteModel.fromMap(Map m1) {
    return ListNoteModel(
      id: m1['id'],
      userId: m1['userId'],
      title: m1['title'],
      points: m1['points'].toString().split('|'),
    );
  }
}
