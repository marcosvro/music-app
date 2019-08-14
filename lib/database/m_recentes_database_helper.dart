import 'dart:async';
import 'package:music_app/database/lyrics_database_helper.dart';
import 'package:music_app/database/musics_database_helper.dart';
import 'package:music_app/database/partitures_databae_helper.dart';
import 'package:music_app/database/tabs_database_helper.dart';
import 'package:music_app/models/lyrics.dart';
import 'package:music_app/models/media.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/models/partiture.dart';
import 'package:music_app/models/tab.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
 
class MRecentDatabaseHelper {
  static final MRecentDatabaseHelper _instance = new MRecentDatabaseHelper.internal();
 
  factory MRecentDatabaseHelper() => _instance;
 
  final String tableMedias = 'lyricsTable';
  final String columnId = 'id';
  final String columnType = 'type';
  final String columnMedia = 'media';
 
  final num maxTuples = 20;

  static Database _db;
 
  MRecentDatabaseHelper.internal();
 
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 
  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'recent.db');
 
    await deleteDatabase(path); // just for testing
 
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
 
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableMedias($columnId INTEGER PRIMARY KEY, $columnType TEXT, $columnMedia INTEGER)'
    );
  }
 
  Future<List> getAllRecentMedias () async {
    var dbClient = await db;
    var dbMusics = new MusicsDatabaseHelper();
    var dbLyrics = new LyricsDatabaseHelper();
    var dbTabs = new TabsDatabaseHelper();
    var dbPartitures = new PartituresDatabaseHelper();

    List<Media> midasList = [];

    await dbClient.transaction((txn) async {
      var res = await txn.query(tableMedias, columns: [columnId, columnType, columnMedia]);

      res = res.toList();

      for (dynamic media in res) {
        final tipo = media['type'];
        final id = media['id'];
        final midiaID = media['media'];

        if (tipo == 'Music') {
          MusicModel r = await dbMusics.getMusic(midiaID);
          if (r != null)
            midasList.add(r);
          else
            await txn.delete(tableMedias, where: '$columnId = ?', whereArgs: [id]);
        } else if (tipo == 'Lyric') {
          LyricsModel r = await dbLyrics.getLyric(midiaID);
          if (r != null)
            midasList.add(r);
          else
            await txn.delete(tableMedias, where: '$columnId = ?', whereArgs: [id]);
        } else if (tipo == 'Tab') {
          TabModel r = await dbTabs.getTab(midiaID);
          if (r != null)
            midasList.add(r);
          else
            await txn.delete(tableMedias, where: '$columnId = ?', whereArgs: [id]);
        } else if (tipo == 'Partiture'){
          PartitureModel r = await dbPartitures.getPartiture(midiaID);
          if (r != null)
            midasList.add(r);
          else
            await txn.delete(tableMedias, where: '$columnId = ?', whereArgs: [id]);
        } else {
          await txn.delete(tableMedias, where: '$columnId = ?', whereArgs: [id]);
        }
      }
    });

    return midasList;
  }

  Future<int> insertRecentMedia (Media item) async {
    var dbClient = await db;
    int newId;

    await dbClient.transaction((tnx) async {
      final cont = Sqflite.firstIntValue(await tnx.rawQuery('SELECT COUNT(*) FROM $tableMedias'));

      if (cont > maxTuples) {
        var oldMidia = await tnx.rawQuery('SELECT * FROM $tableMedias ORDER BY $columnId ASC LIMIT 1');
        final oldMidiaId = oldMidia.first['id'];

        newId = await tnx.insert(tableMedias , item.toJson());
        await tnx.delete(tableMedias, where: '$columnId = ?', whereArgs: [oldMidiaId]);
      } else {
        newId = await tnx.insert(tableMedias , item.toJson());
      }
    });

    return newId;
  } 

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}