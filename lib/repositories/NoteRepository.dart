import 'package:secret_diary/database/DBHelper.dart';
import 'package:secret_diary/model/Note.dart';

class NoteRepository {
  DBHelper dbHelper = DBHelper();
  Future<List<Note>> getNote() async {
    var dbClient = await dbHelper.db;

    List<Map> maps = await dbClient.query(Note().tableName,
        columns: ['id', 'title', 'note', 'date'], orderBy: 'id DESC');
    List<Note> note = [];
    for (int i = 0; i < maps.length; i++) {
      note.add(Note.fromMap(maps[i]));
    }
    return note;
  }

  Future<List<Note>> whereNote(String date) async {
    var dbClient = await dbHelper.db;
    List<dynamic> whereArguments = [date];
    List<Map> maps = await dbClient.query(Note().tableName,
        columns: ['id', 'title', 'note', 'date'],
        where: 'date=?',
        whereArgs: whereArguments,
        orderBy: 'id DESC');
    List<Note> note = [];
    for (int i = 0; i < maps.length; i++) {
      note.add(Note.fromMap(maps[i]));
    }
    return note;
  }

  Future<List<Note>> oneNote() async {
    var dbClient = await dbHelper.db;

    List<Map> maps = await dbClient.query(Note().tableName,
        columns: ['id', 'title', 'note', 'date'],
        where: 'id = ?',
        whereArgs: [1]);
    List<Note> note = [];
    // print(maps);
    if (maps.length > 0) {
      note.add(Note.fromMap(maps[0]));
    }
    return note;
  }

  Future<int> add(Note note) async {
    var dbClient = await dbHelper.db;
    return await dbClient.insert(note.tableName, note.toMap());
  }

  Future<int> update(Note note) async {
    var dbClient = await dbHelper.db;
    return await dbClient.update(note.tableName, note.toMap(),
        where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    var dbClient = await dbHelper.db;
    return await dbClient
        .delete(Note().tableName, where: 'id = ?', whereArgs: [id]);
  }
}
