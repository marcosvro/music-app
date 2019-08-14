import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/widgets/scrollingText.widget.dart';

class MiniPlayer extends StatefulWidget {
  MusicModel music = null;
  String command = "";
  
  MiniPlayer({this.music, this.command, Key key}) : super (key : key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();

  
}

class _MiniPlayerState extends State<MiniPlayer> {
  final contentHeight = 60.0;
  final iconsWidth = 50.0;
  final maxDescLenght = 30;
  final descFontSize = 15.0;
  final backgroundColor = Colors.black.withOpacity(0.9);

  //bool playing;
  bool loading = false;
  bool playing = true;
  AudioPlayer advancedPlayer; 
  Duration duration;
  Duration position;

  void switchPlay () {
    setState(() {
      //loading = false;
      if (playing) {
        advancedPlayer.pause();
        setState(() {
          playing = false;
        });
      } else {
        advancedPlayer.resume();
        setState(() {
          playing = true;
        });
      }
      //play or stop music
    });
  }

  Future loadMusic() async {
    setState(() {
      loading = true;
      playing = false;
    });
    advancedPlayer = await AudioCache().play(widget.music.pathFile);
    //advancedPlayer.setUrl(widget.music.pathFile, isLocal: true);
    /*if (!playing){
      advancedPlayer.pause();
      advancedPlayer.seek(Duration(seconds: 0));
    }*/

    //await advancedPlayer.seek(Duration(seconds: 0));
    advancedPlayer.onDurationChanged.listen((d) => setState(() => duration = d));
    advancedPlayer.onAudioPositionChanged.listen((p) => setState(() => position = p));
    setState(() {
      loading = false;
      playing = true;
    });
  }

  @override
  void didUpdateWidget(MiniPlayer oldWidget) {
    
    if (widget.music != oldWidget.music && widget.music != null) {
      print("Mudei a musica!");
      print(widget.music.toString());
      if (oldWidget.music != null) {
        advancedPlayer.stop();
        advancedPlayer.release();
      }
      loadMusic();
    }

    if (widget.command != oldWidget.command && widget.command != "") {
      print("Mudei o comando!");
      print(widget.command);
      switch (widget.command) {
        case "STOP":
          if (oldWidget.music != null) {
            advancedPlayer.stop();
            advancedPlayer.release();
          }
          setState(() {
            widget.music = null;
            playing = false;
          });
          break;
        case "PLAY":
          if (widget.music != null) {
            advancedPlayer.resume();
            setState(() {
              playing = true;
            });
          }
          break;
        case "RESUME":
          if (widget.music != null) {
            advancedPlayer.resume();
            setState(() {
              playing = true;
            });
          }
          break;
        default:
          print ("Inválid command !!");
          break;
      }
      setState(() {
        widget.command = "";
      });
    }
    
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    //advancedPlayer = AudioPlayer();
    /*setState(() {
      widget.command = "";
      playing = true;
    })*/
    //loadMusic();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    advancedPlayer.stop();
    advancedPlayer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print (advancedPlayer);
    var formatedText = "";
    if (widget.music != null)
      formatedText = widget.music.title+" - "+widget.music.author;
    if (formatedText.length > maxDescLenght) {
      formatedText = formatedText.substring(0, maxDescLenght-3)+"..";
    }

    return widget.music != null && !loading ? Container(
      height: contentHeight,
      color: backgroundColor,
      child: Column (
        children: <Widget>[
          duration != null && position != null ? SliderTheme(
            data: SliderThemeData(
              disabledActiveTrackColor: Colors.deepOrange,
              disabledInactiveTrackColor: Colors.white.withOpacity(0.8),
              trackHeight: 4.0,
              thumbColor: Colors.deepOrange,
              thumbShape: RoundSliderThumbShape(disabledThumbRadius: 0),
              overlayColor: Colors.deepOrange,
              overlayShape: RoundSliderThumbShape(disabledThumbRadius: 0),
            ),
            child: Slider(
              onChanged: null,
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
            )
          ): SizedBox(height: 0,),
          Expanded (
            child: Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container (
                  width: iconsWidth,
                  //color: Colors.yellow,
                  child: FlatButton(
                    child: Center(
                      child: Icon (
                        playing ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: switchPlay,
                  ),
                ),
                Expanded (
                  child: Center (
                    child: Text(
                      formatedText,
                      style: TextStyle (
                        color: Colors.white,
                        fontSize: descFontSize,
                      ),
                    ),
                  ),
                ),
                Container (
                  width: iconsWidth,
                  //color: Colors.yellow,
                  child: FlatButton(
                    child: Center(
                      child: Icon (
                        Icons.keyboard_arrow_up,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.white.withOpacity(0.2),
            height: 2,
          ),
        ],
      ),
    ): SizedBox (width: 0, height: 0,);
  }
}