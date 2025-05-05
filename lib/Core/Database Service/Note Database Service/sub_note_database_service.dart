import 'package:note_tracking_app/Core/Database%20Service/database_service.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/sub_note_model.dart';

class SubNoteDatabaseService {
  final dbHelper = DbHelper.helper;

  Future<void> addSubNote(SubNoteModel subNote) async {
    final dbClient = await dbHelper.database;
    await dbClient!.insert('subNotes', subNote.toMap());
  }

  Future<List<SubNoteModel>> readSubNote(int noteId) async {
    final dbClient = await dbHelper.database;
    final maps = await dbClient!.query(
      'subNotes',
      where: 'noteId = ?',
      whereArgs: [noteId],
    );
    return maps
        .map(
          (e) => SubNoteModel.fromMap(e),
        )
        .toList();
  }

  Future<void> updateSubNote(SubNoteModel subNote) async {
    final dbClient = await dbHelper.database;
    await dbClient!.update(
      'subNotes',
      subNote.toMap(),
      where: 'id = ?',
      whereArgs: [subNote.id],
    );
  }

  Future<List<SubNoteModel>> searchByTitle(String search) async {
    final dbClient = await dbHelper.database;
    final result = await dbClient!.query(
      'subNotes',
      where: 'title LIKE ?',
      whereArgs: ['%$search%'],
    );
    return result
        .map(
          (e) => SubNoteModel.fromMap(e),
        )
        .toList();
  }

  Future<void> deleteSubNote(int id) async {
    final dbClient = await dbHelper.database;
    await dbClient!.delete(
      'subNotes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
