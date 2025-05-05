class NoteModel {
  int? id;
  final int userId;
  final String title;
  final String description;
  bool view;

  NoteModel({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.view = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
    };
  }

  factory NoteModel.fromMap(Map m1) {
    return NoteModel(
      id: m1['id'],
      userId: m1['userId'],
      title: m1['title'],
      description: m1['description'],
    );
  }
}
