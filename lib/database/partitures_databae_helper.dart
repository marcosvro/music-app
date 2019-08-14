import 'dart:async';
import 'package:music_app/models/partiture.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PartituresDatabaseHelper {
  static final PartituresDatabaseHelper _instance = new PartituresDatabaseHelper.internal();
 
  factory PartituresDatabaseHelper() => _instance;
 
  final String tablePartiture = 'partitureTable';
  final String columnId = 'id';
  final String columnPathFile = 'pathFile';
  final String columnTitle = 'title';
  final String columnAuthor = 'author';
 
  static Database _db;
 
  PartituresDatabaseHelper.internal();
 
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 
  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'partiture.db');
 
    await deleteDatabase(path); // just for testing
 
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
 
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tablePartiture($columnId INTEGER PRIMARY KEY, $columnPathFile TEXT, $columnTitle TEXT, $columnAuthor TEXT)'
    );
  }
 
  Future<int> savePartiture(PartitureModel partiture) async {
    var dbClient = await db;
    var result = await dbClient.insert(tablePartiture, partiture.toJson());
    //    var result = await dbClient.rawInsert(
    //        'INSERT INTO $tablePartiture ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')'); 
    return result;
  }
 
  Future<List> getAllPartitures() async {
    var dbClient = await db;
    var result = await dbClient.query(tablePartiture, columns: [columnId, columnPathFile, columnTitle, columnAuthor]);
    //    var result = await dbClient.rawQuery('SELECT * FROM $tablePartiture');
    result = result.toList();
    List<PartitureModel> ret = [];
    for (Map item in result) {
      ret.add(PartitureModel.fromJson(item));
    }
    return ret;
  }
 
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tablePartiture'));
  }
 
  Future<PartitureModel> getPartiture(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tablePartiture,
        columns: [columnId, columnPathFile, columnTitle, columnAuthor],
        where: '$columnId = ?',
        whereArgs: [id]);
    //    var result = await dbClient.rawQuery('SELECT * FROM $tablePartiture WHERE $columnId = $id');
    if (result.length > 0) {
      return new PartitureModel.fromJson(result.first);
    }
 
    return null;
  }
 
  Future<int> deletePartiture(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tablePartiture, where: '$columnId = ?', whereArgs: [id]);
    //    return await dbClient.rawDelete('DELETE FROM $tablePartiture WHERE $columnId = $id');
  }
 
  Future<int> updatePartiture(PartitureModel partiture) async {
    var dbClient = await db;
    return await dbClient.update(tablePartiture, partiture.toJson(), where: "$columnId = ?", whereArgs: [partiture.id]);
    //    return await dbClient.rawUpdate(
    //        'UPDATE $tablePartiture SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}