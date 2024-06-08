import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    String path = await getDatabasesPath() + 'notes.db';
    var db = openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) {
    db.execute(
        "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(255))");
    db.execute(
        "CREATE TABLE passcode(id INTEGER PRIMARY KEY AUTOINCREMENT, code VARCHAR(8),email VARCHAR(255))");
    db.execute(
        "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR(255),note TEXT,date DATETIME, mood INTEGER);");
    db.execute(
        "INSERT INTO notes (title,note,date) VALUES('Demo',  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',  '2022-01-01');");
  }
}
