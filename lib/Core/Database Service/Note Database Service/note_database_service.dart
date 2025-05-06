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

  Future<void> getNoteById(int id) async {
    final dbClient = await dbHelper.database;
    await dbClient!.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> searchResult(String search) async {
    final dbClient = await dbHelper.database;

    final matchSubNote = await dbClient!.query(
      'subNotes',
      where: 'title LIKE ?',
      whereArgs: ['%$search%'],
    );
    final subNotesId = matchSubNote
        .map(
          (e) => e['noteId'],
        )
        .toSet();

    final matchNote = await dbClient.query(
      'notes',
      where: 'title LIKE ?',
      whereArgs: ['%$search%'],
    );

    final noteId = matchNote
        .map(
          (e) => e['id'],
        )
        .toSet();
    final allNotes = {...subNotesId, ...noteId}.toList();
    if (allNotes.isEmpty) return [];
    final result = await dbClient.query(
      'notes',
      where: 'id IN (${allNotes.join(',')})',
    );
    return result;
  }
}
