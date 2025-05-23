import 'package:note_tracking_app/Core/Database%20Service/database_service.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/note_model.dart';

class NoteDatabaseService {
  final dbHelper = DbHelper.helper;

  Future<void> addNote(NoteModel note) async {
    final dbClient = await dbHelper.database;
    await dbClient!.insert('notes', note.toMap());
  }

  Future<List<NoteModel>> readNote(int userId) async {
    final dbClient = await dbHelper.database;
    final maps = await dbClient!.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps
        .map(
          (e) => NoteModel.fromMap(e),
        )
        .toList();
  }

  Future<void> updateNote(NoteModel note) async {
    final dbClient = await dbHelper.database;
    await dbClient!.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final dbClient = await dbHelper.database;
    await dbClient!.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> searchResult(
      String search, int currentUserId) async {
    final dbClient = await dbHelper.database;
    final userNotes = await dbClient!.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [currentUserId],
    );
    final userNoteIds = userNotes
        .map(
          (e) => e['id'],
        )
        .toSet();
    final matchSubNote = await dbClient.query(
      'subNotes',
      where: 'title LIKE ?',
      whereArgs: ['%$search%'],
    );
    final filterSubNotes = matchSubNote.where(
      (element) => userNoteIds.contains(element['noteId']),
    );
    final matchNote = await dbClient.query(
      'notes',
      where: 'title LIKE ? AND userId = ?',
      whereArgs: ['%$search%', currentUserId],
    );
    final noteResult = matchNote
        .map(
          (note) => {
            'note': 'note',
            'noteId': note['id'],
            'title': note['title'],
            'description': note['description']
          },
        )
        .toList();
    final subNoteResult = filterSubNotes
        .map(
          (sub) => {
            'note': 'subNote',
            'noteId': sub['noteId'],
            'title': sub['title'],
            'description': sub['description']
          },
        )
        .toList();
    final allNotes = [...noteResult, ...subNoteResult];
    if (allNotes.isEmpty) return [];
    return allNotes;
  }
}
