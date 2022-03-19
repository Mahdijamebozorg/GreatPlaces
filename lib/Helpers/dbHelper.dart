import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sqlite;

class DBHelper {
  static Future<sqlite.Database> dataBase(String table) async {
    //path to dataBase
    final String sqlPath = await sqlite.getDatabasesPath();
    //open dataBase
    return await sqlite.openDatabase(path.join(sqlPath, "palces.db"),
        onCreate: (db, version) async {
      return db.execute(
          "CREATE TABLE $table(id TEXT PRIMARY KEY, title TEXT, imageUrl TEXT)");
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> values) async {
    final dataBase = await DBHelper.dataBase(table);
    //insert data to dataBase
    await dataBase.insert(table, values,
        conflictAlgorithm: sqlite.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final dataBase = await DBHelper.dataBase(table);
    //get data from dataBase
    return dataBase.query(table);
  }

  static Future<void> deleteData(String table, String id) async {
    final dataBase = await DBHelper.dataBase(table);
    await dataBase.delete(table, where: "id = ?", whereArgs: [id]);
  }
}
