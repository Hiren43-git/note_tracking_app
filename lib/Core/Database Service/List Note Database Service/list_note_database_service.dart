import 'package:note_tracking_app/Core/Database%20Service/database_service.dart';
import 'package:note_tracking_app/Core/Model/List%20Note%20Model/list_note_model.dart';

class ListNoteDatabaseService {
  final dbHelper = DbHelper.helper;

  Future<void> addListNote(ListNoteModel listNote) async {
    final dbClient = await dbHelper.database;
    await dbClient!.insert('listNotes', listNote.toMap());
  }

  Future<List<ListNoteModel>> readListNote(int userId) async {
    final dbClient = await dbHelper.database;
    final maps = await dbClient!.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((e) => ListNoteModel.fromMap(e)).toList();
  }

  Future<void> updateListNote(ListNoteModel listNote) async {
    final dbClient = await dbHelper.database;
    await dbClient!.update(
      'listNotes',
      listNote.toMap(),
      where: 'id = ?',
      whereArgs: [listNote.id],
    );
  }

  Future<void> deleteListNote(int id) async {
    final dbClient = await dbHelper.database;
    await dbClient!.delete(
      'listNotes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
