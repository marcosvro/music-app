import 'dart:async';
import 'package:music_app/models/tab.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
 
class TabsDatabaseHelper {
  static final TabsDatabaseHelper _instance = new TabsDatabaseHelper.internal();
 
  factory TabsDatabaseHelper() => _instance;
 
  final String tableTab = 'tabTable';
  final String columnId = 'id';
  final String columnPathFile = 'pathFile';
  final String columnTitle = 'title';
  final String columnAuthor = 'author';
 
  static Database _db;
 
  TabsDatabaseHelper.internal();
 
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 
  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'tab.db');
 
    await deleteDatabase(path); // just for testing
 
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
 
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableTab($columnId INTEGER PRIMARY KEY, $columnPathFile TEXT, $columnTitle TEXT, $columnAuthor TEXT)'
    );
  }
 
  Future<int> saveTab(TabModel tab) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableTab, tab.toJson());
    //    var result = await dbClient.rawInsert(
    //        'INSERT INTO $tableTab ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')'); 
    return result;
  }
 
  Future<List> getAllTabs() async {
    var dbClient = await db;
    var result = await dbClient.query(tableTab, columns: [columnId, columnPathFile, columnTitle, columnAuthor]);
    //    var result = await dbClient.rawQuery('SELECT * FROM $tableTab');
    result = result.toList();
    List<TabModel> ret = [];
    for (Map item in result) {
      ret.add(TabModel.fromJson(item));
    }
    return ret;
  }
 
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableTab'));
  }
 
  Future<TabModel> getTab(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableTab,
        columns: [columnId, columnPathFile, columnTitle, columnAuthor],
        where: '$columnId = ?',
        whereArgs: [id]);
    //    var result = await dbClient.rawQuery('SELECT * FROM $tableTab WHERE $columnId = $id');
 
    if (result.length > 0) {
      return new TabModel.fromJson(result.first);
    }
 
    return null;
  }
 
  Future<int> deleteTab(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableTab, where: '$columnId = ?', whereArgs: [id]);
    //    return await dbClient.rawDelete('DELETE FROM $tableTab WHERE $columnId = $id');
  }
 
  Future<int> updatetab(TabModel tab) async {
    var dbClient = await db;
    return await dbClient.update(tableTab, tab.toJson(), where: "$columnId = ?", whereArgs: [tab.id]);
    //    return await dbClient.rawUpdate(
    //        'UPDATE $tableTab SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}