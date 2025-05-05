import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper helper = DbHelper._();
  DbHelper._();

  Database? _database;

  Future<Database?> get database async => _database ?? await initDatabase();

  Future<Database?> initDatabase() async {
    var path = await getDatabasesPath();
    String dbPath = join(path, 'noteApp.db');
    print('Database path : $path');
    // deleteDatabase(path);
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users (id INTEGER PRIMARY KEY ,name TEXT,email TEXT, password TEXT,image Text)
      ''');
        await db.execute('''
        CREATE TABLE notes (id INTEGER PRIMARY KEY ,userId INTEGER,title TEXT,description TEXT)
      ''');
        await db.execute('''
        CREATE TABLE listNotes (id INTEGER PRIMARY KEY ,userId INTEGER,title TEXT,points TEXT)
      ''');
        await db.execute('''
        CREATE TABLE subNotes (id INTEGER PRIMARY KEY ,noteId INTEGER,title TEXT,description TEXT)
      ''');
        await db.execute('''
        CREATE TABLE subListNotes (id INTEGER PRIMARY KEY ,listNoteId INTEGER,title TEXT,points TEXT)
      ''');
      },
    );
  }
}
