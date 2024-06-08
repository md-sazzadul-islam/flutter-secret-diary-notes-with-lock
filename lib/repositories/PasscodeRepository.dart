import 'package:secret_diary/database/DBHelper.dart';
import 'package:secret_diary/model/Passcode.dart';

class PasscodeRepository {
  DBHelper dbHelper = DBHelper();
  Future<List<Passcode>> getPasscode() async {
    var dbClient = await dbHelper.db;

    List<Map> maps = await dbClient
        .query(Passcode().tableName, columns: ['id', 'code', 'email']);
    List<Passcode> passcode = [];
    for (int i = 0; i < maps.length; i++) {
      passcode.add(Passcode.fromMap(maps[i]));
    }
    return passcode;
  }

  Future<List<Passcode>> onePasscode() async {
    var dbClient = await dbHelper.db;

    List<Map> maps = await dbClient.query(Passcode().tableName,
        columns: ['id', 'code', 'email'], where: 'id = ?', whereArgs: [1]);
    List<Passcode> passcode = [];
    // print(maps);
    if (maps.length > 0) {
      passcode.add(Passcode.fromMap(maps[0]));
    }
    return passcode;
  }

  Future<int> add(Passcode passcode) async {
    var dbClient = await dbHelper.db;
    return await dbClient.insert(passcode.tableName, passcode.toMap());
  }

  Future<int> update(Passcode passcode) async {
    var dbClient = await dbHelper.db;
    return await dbClient.update(passcode.tableName, passcode.toMap(),
        where: 'id = ?', whereArgs: [passcode.id]);
  }

  Future<int> delete(int id) async {
    var dbClient = await dbHelper.db;
    return await dbClient
        .delete(Passcode().tableName, where: 'id = ?', whereArgs: [id]);
  }
}
