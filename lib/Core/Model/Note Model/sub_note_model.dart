class SubNoteModel {
  int? id;
  final int noteId;
  final String title;
  final String description;
  bool view;

  SubNoteModel({
    this.id,
    required this.noteId,
    required this.title,
    required this.description,
    this.view = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'noteId': noteId,
      'title': title,
      'description': description,
    };
  }

  factory SubNoteModel.fromMap(Map m1) {
    return SubNoteModel(
      id: m1['id'],
      noteId: m1['noteId'],
      title: m1['title'],
      description: m1['description'],
    );
  }
}
