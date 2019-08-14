import 'package:flutter/material.dart';
import 'package:music_app/models/lyrics.dart';
import 'package:music_app/models/media.dart';
import 'package:music_app/models/music.dart';
import 'listMedia.widgets.dart';

class HomeWidget extends StatefulWidget {

  List<Media> midiasRecentes;
  List<Media> midiasRecomendadas;
  List<Media> midiasTopRated;
  List<Media> midiasAleatorios;

  HomeWidget() {
    midiasRecentes = [];
    midiasRecomendadas = [];
    midiasTopRated = [];
    midiasAleatorios = [];
    midiasRecentes.add(MusicModel(duration : 3, pathFile : "./assets", title : "Uma musica", style : "Trap", author : "Eu"));
    midiasRecentes.add(LyricsModel(pathFile : "./assets", title : "Uma musica", author : "Eu"));
    midiasRecentes.add(MusicModel(duration : 3, pathFile : "./assets", title : "Uma musica", style : "Trap", author : "Eu"));
    midiasRecentes.add(LyricsModel(pathFile : "./assets", title : "Uma musica", author : "Eu"));
    midiasRecentes.add(MusicModel(duration : 3, pathFile : "./assets", title : "Uma musica", style : "Trap", author : "Eu"));
    midiasRecentes.add(LyricsModel(pathFile : "./assets", title : "Uma musica", author : "Eu"));
  }

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(1),
      child: ListView (
        children: <Widget>[
          ListMediaHorizontal("Recentemente acessados", widget.midiasRecentes),
          SizedBox(height: 50,),
          ListMediaHorizontal("Recomendados", widget.midiasRecentes),
          SizedBox(height: 50,),
          ListMediaHorizontal("Bem avaliados", widget.midiasRecentes),
          SizedBox(height: 50,),
          ListMediaHorizontal("Aleatórios", widget.midiasRecentes),
        ],
      ),
    );
  }
}