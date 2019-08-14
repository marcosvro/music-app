import 'dart:async';
import 'package:music_app/models/lyrics.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
 
class LyricsDatabaseHelper {
  static final LyricsDatabaseHelper _instance = new LyricsDatabaseHelper.internal();
 
  factory LyricsDatabaseHelper() => _instance;
 
  final String tableLyrics = 'lyricsTable';
  final String columnId = 'id';
  final String columnPathFile = 'pathFile';
  final String columnTitle = 'title';
  final String columnAuthor = 'author';
 
  static Database _db;
 
  LyricsDatabaseHelper.internal();
 
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 
  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'lyrics.db');
 
    await deleteDatabase(path); // just for testing
 
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
 
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableLyrics($columnId INTEGER PRIMARY KEY, $columnPathFile TEXT, $columnTitle TEXT, $columnAuthor TEXT)'
    );
  }
 
  Future<int> saveLyric(LyricsModel lyric) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableLyrics, lyric.toJson());
    //    var result = await dbClient.rawInsert(
    //        'INSERT INTO $tableLyrics ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')'); 
    return result;
  }
 
  Future<List> getAllLyric() async {
    var dbClient = await db;
    var result = await dbClient.query(tableLyrics, columns: [columnId, columnPathFile, columnTitle, columnAuthor]);
    //    var result = await dbClient.rawQuery('SELECT * FROM $tableLyrics');
    result = result.toList();
    List<LyricsModel> ret = [];
    for (Map item in result) {
      ret.add(LyricsModel.fromJson(item));
    }
    return ret;
  }
 
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableLyrics'));
  }
 
  Future<LyricsModel> getLyric(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableLyrics,
        columns: [columnId, columnPathFile, columnTitle, columnAuthor],
        where: '$columnId = ?',
        whereArgs: [id]);
    //    var result = await dbClient.rawQuery('SELECT * FROM $tableLyrics WHERE $columnId = $id');
 
    if (result.length > 0) {
      return new LyricsModel.fromJson(result.first);
    }
 
    return null;
  }
 
  Future<int> deleteLyric(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableLyrics, where: '$columnId = ?', whereArgs: [id]);
    //    return await dbClient.rawDelete('DELETE FROM $tableLyrics WHERE $columnId = $id');
  }
 
  Future<int> updateLyric(LyricsModel lyric) async {
    var dbClient = await db;
    return await dbClient.update(tableLyrics, lyric.toJson(), where: "$columnId = ?", whereArgs: [lyric.id]);
    //    return await dbClient.rawUpdate(
    //        'UPDATE $tableLyrics SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}