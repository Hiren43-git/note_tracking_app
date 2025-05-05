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

  Future<List<NoteModel>> searchByTitle(String search) async {
    final dbClient = await dbHelper.database;
    final result = await dbClient!.query(
      'notes',
      where: 'title LIKE ?',
      whereArgs: ['%$search%'],
    );
    return result
        .map(
          (e) => NoteModel.fromMap(e),
        )
        .toList();
  }

  Future<void> deleteNote(int id) async {
    final dbClient = await dbHelper.database;
    await dbClient!.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
