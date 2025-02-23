import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'attendance_manager.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE subjects(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          attended INTEGER,
          total INTEGER
        )
      ''');
    });
  }

  Future<int> insertSubject(Map<String, dynamic> subject) async {
    Database db = await database;
    return await db.insert('subjects', subject);
  }

  Future<List<Map<String, dynamic>>> getSubjects() async {
    Database db = await database;
    return await db.query('subjects');
  }

  Future<int> updateSubject(Map<String, dynamic> subject) async {
    Database db = await database;
    return await db.update(
      'subjects',
      subject,
      where: 'id = ?',
      whereArgs: [subject['id']],
    );
  }

  Future<int> deleteSubject(int id) async {
    Database db = await database;
    return await db.delete(
      'subjects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

