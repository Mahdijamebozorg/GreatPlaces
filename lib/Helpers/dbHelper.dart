import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sqlite;

class DBHelper {
  ///opens or creates a dataBase and returns it
  static Future<sqlite.Database> dataBase(String table) async {
    //path to dataBase
    final String sqlPath = await sqlite.getDatabasesPath();
    //open dataBase
    return sqlite.openDatabase(
      //path
      path.join(sqlPath, "palces.db"),
      //when creating
      onCreate: (db, version) {
        print("Creating sqlite DataBase...");
        return db.execute(
          "CREATE TABLE $table (id TEXT PRIMARY KEY, title TEXT, details TEXT, imageUrl TEXT, address Text, latitude TEXT, longitude TEXT)",
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> values) async {
    final dataBase = await DBHelper.dataBase(table);
    print("value to insert: $values");
    //insert data to dataBase
    await dataBase.insert(table, values,
        conflictAlgorithm: sqlite.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final dataBase = await DBHelper.dataBase(table);
    print("sqlite data: ${await dataBase.query(table)}");
    //get data from dataBase
    return dataBase.query(table);
  }

  static Future<void> deleteData(String table, String id) async {
    final dataBase = await DBHelper.dataBase(table);
    final result =
        await dataBase.delete(table, where: "id = ?", whereArgs: [id]);
    print("deleted id: $result");
  }

  static Future<void> updateData(
      String table, Map<String, Object> values, String id) async {
    final dataBase = await DBHelper.dataBase(table);
    final result =
        await dataBase.update(table, values, where: "id = ?", whereArgs: [id]);
    print("updated id: $result");
  }

  static Future<void> resetData(String table) async {
    final dataBase = await DBHelper.dataBase(table);
    dataBase.execute("DELETE FROM $table");
    await sqlite.deleteDatabase(dataBase.path);
    print("DataBase has removed!");
  }
}
