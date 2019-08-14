import 'dart:async';
import 'package:music_app/models/music.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
 
class MusicsDatabaseHelper {
  static final MusicsDatabaseHelper _instance = new MusicsDatabaseHelper.internal();
 
  factory MusicsDatabaseHelper() => _instance;
 
  final String tableMusic = 'musicTable';
  final String columnId = 'id';
  final String columnDuration = 'duration';
  final String columnPathFile = 'pathFile';
  final String columnTitle = 'title';
  final String columnStyle = 'style';
  final String columnAuthor = 'author';
 
  static Database _db;
 
  MusicsDatabaseHelper.internal();
 
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 
  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'music.db');
 
    await deleteDatabase(path); // just for testing
 
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
 
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableMusic($columnId INTEGER PRIMARY KEY, $columnDuration REAL, $columnPathFile TEXT, $columnTitle TEXT, $columnStyle TEXT, $columnAuthor TEXT)'
    );
  }
 
  Future<int> saveMusic(MusicModel music) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableMusic, music.toJson());
    //    var result = await dbClient.rawInsert(
    //        'INSERT INTO $tableMusic ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')'); 
    return result;
  }
 
  Future<List> getAllMusic() async {
    var dbClient = await db;
    var result = await dbClient.query(tableMusic, columns: [columnId, columnDuration, columnPathFile, columnTitle, columnStyle, columnAuthor]);
    //    var result = await dbClient.rawQuery('SELECT * FROM $tableMusic');
    result = result.toList();
    List<MusicModel> ret = [];
    for (Map item in result) {
      ret.add(MusicModel.fromJson(item));
    }
    return ret;
  }
 
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableMusic'));
  }
 
  Future<MusicModel> getMusic(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableMusic,
        columns: [columnId, columnDuration, columnPathFile, columnTitle, columnStyle, columnAuthor],
        where: '$columnId = ?',
        whereArgs: [id]);
    //    var result = await dbClient.rawQuery('SELECT * FROM $tableMusic WHERE $columnId = $id');
 
    if (result.length > 0) {
      return new MusicModel.fromJson(result.first);
    }
 
    return null;
  }
 
  Future<int> deleteMusic(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableMusic, where: '$columnId = ?', whereArgs: [id]);
    //    return await dbClient.rawDelete('DELETE FROM $tableMusic WHERE $columnId = $id');
  }
 
  Future<int> updateMusic(MusicModel music) async {
    var dbClient = await db;
    return await dbClient.update(tableMusic, music.toJson(), where: "$columnId = ?", whereArgs: [music.id]);
    //    return await dbClient.rawUpdate(
    //        'UPDATE $tableMusic SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}