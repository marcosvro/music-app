import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/widgets/home.widget.dart';
import 'package:music_app/widgets/library.widget.dart';
import 'package:music_app/widgets/miniSongPlayer.widget.dart';
import 'package:music_app/widgets/search.widget.dart';

class MainPage extends StatefulWidget {

  Widget telaAtiva;
  Color homeColor;
  Color searchColor;
  Color libraryColor;

  HomeWidget homePage = HomeWidget();
  SearchWidget seachPage = SearchWidget();
  LibraryWidget libraryPage = LibraryWidget();

  //singleton
  /*
  static final MainPage _mainPage = new MainPage._intertal();
  factory MainPage() {
    return _mainPage;
  }
  MainPage._intertal();
  */


  final MainPageState _soundWaveState=MainPageState();
  @override
  MainPageState createState() => _soundWaveState;
}

class MainPageState extends State<MainPage> with TickerProviderStateMixin<MainPage>  {

  static final PublishSubject<Command> publishSubject=PublishSubject<Command>();
  static MusicModel _musicPlaying;
  static MusicModel get musicPlaying => _musicPlaying;

  MusicModel musicActive;
  String command = "";
  final colorButtonEnable = Color.fromRGBO(247, 74, 2, 1);
  final colorButtonDisable = Colors.white;
  
  StreamSubscription<Command>subscriptionMusic;

  static void changeMusicActie (MusicModel newMusic) {
    publishSubject.sink.add(Command(command: Command.load ,data: newMusic));
    _musicPlaying = newMusic;
  }

  static void setCommand (String cmd) {
    
  }

  @override
  void initState() {
    // TODO: implement initState

    
    subscriptionMusic = publishSubject.listen((cmd){
      if (cmd.command == Command.load)
        setState(() {
          musicActive = cmd.data;
        });
      else if (cmd.command == Command.play)
        setState(() {
          command = Command.play;
        });
      else if (cmd.command == Command.stop)
        setState(() {
          command = Command.stop;
        });
    });

    setState(() {
      widget.telaAtiva = widget.libraryPage;
      widget.homeColor = colorButtonDisable;
      widget.searchColor = colorButtonDisable;
      widget.libraryColor = colorButtonEnable;
    });
    super.initState();
  }

  @override
  void dispose() {
    publishSubject.close();
    subscriptionMusic.cancel();
    super.dispose();
  }

  goToHome() {
    setState(() {
      widget.telaAtiva = widget.homePage;
      widget.homeColor = colorButtonEnable;
      widget.searchColor = colorButtonDisable;
      widget.libraryColor = colorButtonDisable;
    });
  }
  goToSearch() {
    setState(() {
      widget.telaAtiva = widget.seachPage;
      widget.homeColor = colorButtonDisable;
      widget.searchColor = colorButtonEnable;
      widget.libraryColor = colorButtonDisable;
    });
  }
  goToLibrary() {
    setState(() {
      widget.telaAtiva = widget.libraryPage;
      widget.homeColor = colorButtonDisable;
      widget.searchColor = colorButtonDisable;
      widget.libraryColor = colorButtonEnable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.9),
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded (
            child: widget.telaAtiva,
          ),
          MiniPlayer(
            music: musicActive,
            command: command,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.black.withOpacity(0.9),
        child: Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            //botão home
            Container(
              width: 110,
              child: FlatButton(
                //color: Colors.white.withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      color: widget.homeColor,
                    ),
                    Text(
                      "Home",
                      style: TextStyle (
                        color: widget.homeColor
                      ),
                    ),
                  ],
                ),
                onPressed: goToHome,
              ),
            ),

            //botão search
            Container(
              width: 110,
              child: FlatButton(
                //color: Colors.white.withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: widget.searchColor,
                    ),
                    Text(
                      "Buscar",
                      style: TextStyle (
                        color: widget.searchColor
                      ),
                    ),
                  ],
                ),
                onPressed: goToSearch,
              ),
            ),

            //botão library
            Container(
              width: 110,
              child: FlatButton(
                //color: Colors.white.withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.library_music,
                      color: widget.libraryColor,
                    ),
                    Text(
                      "Biblioteca",
                      style: TextStyle (
                        color: widget.libraryColor,
                      ),
                    ),
                  ],
                ),
                onPressed: goToLibrary,
              ),
            ),
          ],
        )
      ),
    );
  }
}


class Command
{
  static final String play="PLAY",pause="PAUSE",load="LOAD", resume="RESUME", stop="STOP";
  final String command;
  final dynamic data;

  static final String createPosition="changePosition";

  Command({this.command, this.data});
}