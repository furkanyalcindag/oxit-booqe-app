import 'package:oxit_booqe_app/models/User.dart';
import 'package:sqflite/sqflite.dart';

final String tableUser = 'user';
final String columnId = 'id';
final String columnUserName = 'username';
final String columnPassword = 'password';

class UserProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableUser ( 
  $columnId integer primary key autoincrement, 
  $columnUserName text not null,
  $columnPassword text not null)
''');
    });
  }

  Future<User> insert(User user) async {
    await open("user.db");
    user.id = await db.insert(tableUser, user.toMap());
    return user;
  }

  Future<User> getUser(int id) async {
    await open("user.db");
    List<Map> maps = await db.query(tableUser,
        columns: [columnId, columnUserName, columnPassword],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User> getUserAll() async {
    await open("user.db");
    List<Map> maps = await db
        .query(tableUser, columns: [columnId, columnUserName, columnPassword]);
    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    await open("user.db");
    return await db.delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    await open("user.db");
    return await db.update(tableUser, user.toMap(),
        where: '$columnId = ?', whereArgs: [user.id]);
  }

  Future close() async => db.close();
}
