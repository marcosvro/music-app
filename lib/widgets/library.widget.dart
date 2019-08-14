import 'package:flutter/material.dart';
import 'package:music_app/database/lyrics_database_helper.dart';
import 'package:music_app/database/musics_database_helper.dart';
import 'package:music_app/database/partitures_databae_helper.dart';
import 'package:music_app/database/tabs_database_helper.dart';
import 'package:music_app/models/lyrics.dart';
import 'package:music_app/models/media.dart';
import 'package:music_app/models/music.dart';

import 'listMedia.widgets.dart';


class LibraryWidget extends StatefulWidget {
  
  MusicsDatabaseHelper dbMusic;
  LyricsDatabaseHelper dbLyric;
  TabsDatabaseHelper dbTab;
  PartituresDatabaseHelper dbPartiture;

  LibraryWidget () {
    dbMusic = new MusicsDatabaseHelper();
    dbLyric = new LyricsDatabaseHelper();
    dbTab = new TabsDatabaseHelper();
    dbPartiture = new PartituresDatabaseHelper();

    List<MusicModel> testMidias = [];

    testMidias.add(MusicModel(duration : 3, pathFile : "musics/24horasdeamor.mp3", title : "24 horas de amor", style : "Sertanejo", author : "Bruno e Marrone"));
    //testMidias.add(LyricsModel(pathFile : "./assets", title : "Uma musica", author : "Eu"));
    testMidias.add(MusicModel(duration : 3, pathFile : "musics/agarrada_em_min.mp3", title : "Agarrada em min", style : "Sertanejo", author : "Bruno e Marrone"));
    //testMidias.add(LyricsModel(pathFile : "./assets", title : "Uma musica", author : "Eu"));
    testMidias.add(MusicModel(duration : 3, pathFile : "musics/passou_da_conta.mp3", title : "Passou da conta", style : "Sertanejo", author : "Bruno e Marrone"));
    //testMidias.add(LyricsModel(pathFile : "./assets", title : "Uma musica", author : "Eu"));

    //just for test
    for (MusicModel item in testMidias) {
      dbMusic.saveMusic(item);
    }
  }

  @override
  _LibraryWidgetState createState() => _LibraryWidgetState();
}

class _LibraryWidgetState extends State<LibraryWidget> {
  final buttonMidiasWidth = 80.0;
  final buttonColorEnable = Color.fromRGBO(247, 74, 2, 1);
  final buttonColorDisable = Colors.white;

  Color colorMusicButton;
  Color colorLyricButton;
  Color colorTabButton;
  Color colorPartitureButton;
  List<Media> midias;
  bool loadingMedias;
  String currentMidia;

  void showMusicList() async {
    setState(() {
      currentMidia = "música";
      loadingMedias = true;
      colorMusicButton = buttonColorEnable;
      colorLyricButton = buttonColorDisable;
      colorTabButton = buttonColorDisable;
      colorPartitureButton = buttonColorDisable;
    });
    var futureMedias = (await widget.dbMusic.getAllMusic()) as List<Media>;
    setState(() {
      midias = futureMedias;
      loadingMedias = false;
    });
  }
  void showLyricList() async {
    setState(() {
      currentMidia = "letra";
      loadingMedias = true;
      colorMusicButton = buttonColorDisable;
      colorLyricButton = buttonColorEnable;
      colorTabButton = buttonColorDisable;
      colorPartitureButton = buttonColorDisable;
    });
    var futureMedias = (await widget.dbLyric.getAllLyric()) as List<Media>;
    setState(() {
      midias = futureMedias;
      loadingMedias = false;
    });
  }
  void showTabList() async {
    setState(() {
      currentMidia = "tablatura";
      loadingMedias = true;
      colorMusicButton = buttonColorDisable;
      colorLyricButton = buttonColorDisable;
      colorTabButton = buttonColorEnable;
      colorPartitureButton = buttonColorDisable;
    });
    var futureMedias =(await widget.dbTab.getAllTabs()) as List<Media>;
    setState(() {
      midias = futureMedias;
      loadingMedias = false;
    });
  }
  void showPartitureList() async {
    setState(() {
      currentMidia = "partitura";
      loadingMedias= true;
      colorMusicButton = buttonColorDisable;
      colorLyricButton = buttonColorDisable;
      colorTabButton = buttonColorDisable;
      colorPartitureButton = buttonColorEnable;
    });
    var futureMedias = (await widget.dbPartiture.getAllPartitures()) as List<Media>;
    setState(() {
      midias = futureMedias;
      loadingMedias= false;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    showMusicList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(1),
      child: SizedBox.expand(
        child: Column(
          children: <Widget>[
            SizedBox(height: 4,),
            Container(
              height: 50,
              width: 340,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    //color: Colors.deepOrange,
                    width: buttonMidiasWidth,
                    child: FlatButton(
                      child: Center (
                        child: Icon(
                          Icons.headset,
                          color: colorMusicButton,
                        ),
                      ),
                      onPressed: showMusicList,
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white.withOpacity(0.2),
                    indent: 5.0,
                    endIndent: 5.0,
                    width: 0,
                  ),
                  Container(
                    //color: Colors.deepOrange,
                    width: buttonMidiasWidth,
                    child: FlatButton(
                      child: Center (
                        child: Icon(
                          Icons.library_books,
                          color: colorLyricButton,
                        ),
                      ),
                      onPressed: showLyricList,
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white.withOpacity(0.2),
                    indent: 5.0,
                    endIndent: 5.0,
                    width: 0,
                  ),
                  Container(
                    //color: Colors.deepOrange,
                    width: buttonMidiasWidth,
                    child: FlatButton(
                      child: Center (
                        child: Icon(
                          Icons.queue_music,
                          color: colorTabButton,
                        ),
                      ),
                      onPressed: showTabList,
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white.withOpacity(0.2),
                    indent: 5.0,
                    endIndent: 5.0,
                    width: 0,
                  ),
                  Container(
                    //color: Colors.deepOrange,
                    width: buttonMidiasWidth,
                    child: FlatButton(
                      child: Center (
                        child: Icon(
                          Icons.music_note,
                          color: colorPartitureButton,
                        ),
                      ),
                      onPressed: showPartitureList,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0,),
            loadingMedias ? Expanded(child: Center(child: CircularProgressIndicator())): SizedBox(height: 0),
            !loadingMedias && midias != null && midias.length > 0 ? ListMediaVertical(midias) : SizedBox(height: 0),
            !loadingMedias && (midias == null || midias.length == 0) ? Expanded(child: Center(
              child: Text(
                "Nenuma "+currentMidia+" encontrada..",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            )): SizedBox (height: 0),
          ],
        ),
      )
    );
  }
}