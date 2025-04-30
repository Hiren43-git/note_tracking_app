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
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        print('Database created');

        await db.execute('''
        CREATE TABLE users (id INTEGER PRIMARY KEY ,name TEXT,email TEXT, password TEXT,image Text)
      ''');

        await db.execute('''
        CREATE TABLE notes (id INTEGER PRIMARY KEY ,userId INTEGER,title TEXT,description TEXT)
      ''');
        await db.execute('''
        CREATE TABLE listNotes (id INTEGER PRIMARY KEY ,userId INTEGER,title TEXT,points TEXT)
      ''');
      },
      onOpen: (db) {
        print('Database open');
      },
    );
  }
}
