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
      'listNotes',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((e) => ListNoteModel.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> searchResult(String search) async {
    final dbClient = await dbHelper.database;

    final matchSubNote = await dbClient!.query(
      'subListNotes',
      where: 'title LIKE ?',
      whereArgs: ['%$search%'],
    );
    final subNotesId = matchSubNote
        .map(
          (e) => e['listNoteId'],
        )
        .toSet();

    final matchNote = await dbClient.query(
      'listNotes',
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
      'listNotes',
      where: 'id IN (${allNotes.join(',')})',
    );
    return result;
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
