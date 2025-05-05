import 'package:note_tracking_app/Core/Database%20Service/database_service.dart';
import 'package:note_tracking_app/Core/Model/List%20Note%20Model/sub_list_model.dart';

class SubListNoteDatabaseService {
  final dbHelper = DbHelper.helper;

  Future<void> addSubListNote(SubListNoteModel subListNote) async {
    final dbClient = await dbHelper.database;
    await dbClient!.insert('subListNotes', subListNote.toMap());
  }

  Future<List<SubListNoteModel>> readSubListNote(int listNoteId) async {
    final dbClient = await dbHelper.database;
    final maps = await dbClient!.query(
      'subListNotes',
      where: 'listNoteId = ?',
      whereArgs: [listNoteId],
    );
    return maps.map((e) => SubListNoteModel.fromMap(e)).toList();
  }

  Future<List<SubListNoteModel>> searchByTitle(String search) async {
    final dbClient = await dbHelper.database;
    final result = await dbClient!
        .query('subListNotes', where: 'title LIKE ?', whereArgs: ['%$search%']);
    return result
        .map(
          (e) => SubListNoteModel.fromMap(e),
        )
        .toList();
  }

  Future<void> updateSubListNote(SubListNoteModel subListNote) async {
    final dbClient = await dbHelper.database;
    await dbClient!.update(
      'subListNotes',
      subListNote.toMap(),
      where: 'id = ?',
      whereArgs: [subListNote.id],
    );
  }

  Future<void> deleteSubListNote(int id) async {
    final dbClient = await dbHelper.database;
    await dbClient!.delete(
      'subListNotes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
