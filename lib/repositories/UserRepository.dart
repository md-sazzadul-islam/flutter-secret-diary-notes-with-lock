import 'package:secret_diary/database/DBHelper.dart';
import 'package:secret_diary/model/User.dart';

class UserRepository {
  DBHelper dbHelper = DBHelper();
  Future<List<User>> getUser() async {
    var dbClient = await dbHelper.db;

    List<Map> maps =
        await dbClient.query(User().tableName, columns: ['id', 'name']);
    List<User> user = [];
    for (int i = 0; i < maps.length; i++) {
      user.add(User.fromMap(maps[i]));
    }
    return user;
  }

  Future<List<User>> oneUser() async {
    var dbClient = await dbHelper.db;

    List<Map> maps = await dbClient.query(User().tableName,
        columns: ['id', 'name'], where: 'id = ?', whereArgs: [1]);
    List<User> user = [];
    // print(maps);
    if (maps.length > 0) {
      user.add(User.fromMap(maps[0]));
    }
    return user;
  }

  Future<int> add(User user) async {
    var dbClient = await dbHelper.db;
    return await dbClient.insert(user.tableName, user.toMap());
  }

  Future<int> update(User user) async {
    var dbClient = await dbHelper.db;
    return await dbClient.update(user.tableName, user.toMap(),
        where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> delete(int id) async {
    var dbClient = await dbHelper.db;
    return await dbClient
        .delete(User().tableName, where: 'id = ?', whereArgs: [id]);
  }
}
