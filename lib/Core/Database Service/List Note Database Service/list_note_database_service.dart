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

  Future<List<Map<String, dynamic>>> searchResult(
      String search, int currentUserId) async {
    final dbClient = await dbHelper.database;
    final userNotes = await dbClient!.query(
      'listNotes',
      where: 'userId = ?',
      whereArgs: [currentUserId],
    );
    final userNoteIds = userNotes
        .map(
          (e) => e['id'],
        )
        .toSet();
    final matchSubNote = await dbClient.query(
      'subListNotes',
      where: 'title LIKE ?',
      whereArgs: ['%$search%'],
    );
    final filterSubNotes = matchSubNote.where(
      (element) => userNoteIds.contains(element['listNoteId']),
    );
    final matchNote = await dbClient.query(
      'listNotes',
      where: 'title LIKE ? AND userId = ?',
      whereArgs: ['%$search%', currentUserId],
    );
    final Map<String, Map<String, dynamic>> noteResult = {};
    for (var note in matchNote) {
      final title = note['title'] as String;
      final point = note['points']?.toString();
      final pointList = point!.split('|');
      if (!noteResult.containsKey(title)) {
        noteResult[title] = {
          'note': 'note',
          'listNoteId': note['id'],
          'title': note['title'],
          'points': pointList
        };
      } else {
        final points = noteResult[title]!['points'] as List;
        points.addAll(pointList);
      }
    }
    final Map<String, Map<String, dynamic>> subNoteResult = {};
    for (var sub in filterSubNotes) {
      final title = sub['title'] as String;
      final point = sub['points']?.toString();
      final pointList = point!.split('|');
      if (!subNoteResult.containsKey(title)) {
        subNoteResult[title] = {
          'note': 'subNote',
          'listNoteId': sub['listNoteId'],
          'title': sub['title'],
          'points': pointList
        };
      } else {
        final points = subNoteResult[title]!['points'] as List;
        points.addAll(pointList);
      }
    }
    final allNotes = [...noteResult.values, ...subNoteResult.values];
    if (allNotes.isEmpty) return [];
    return allNotes;
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
