import 'package:flutter/material.dart';
import 'package:music_app/models/media.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/pages/main.page.dart';
import 'package:music_app/widgets/miniSongPlayer.widget.dart';
import 'itemView.widgets.dart';
import 'itemViewLine.widget.dart';

class ListMediaHorizontal extends StatelessWidget {
  
  String listTitle;
  List<Media> items;

  ListMediaHorizontal(listTitle, items) {
    this.listTitle = listTitle;
    this.items = items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            listTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        Container (
          //color: Colors.blue,
          height: 120,
          child: ListView.builder (
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext ctxt, int i) {
              return ItemViewExtended(items[i]);
            },
          ),
        ),
      ],
    );
  }
}

class ListMediaVertical extends StatefulWidget {

  List<Media> items;
  int mediaIdSelected;

  ListMediaVertical (items) {
    this.mediaIdSelected = -1;
    this.items = items;
  }

  @override
  _ListMediaVerticalState createState() => _ListMediaVerticalState();
}

class _ListMediaVerticalState extends State<ListMediaVertical> {
  
  void tapeMedia (int id) {
    setState(() {
      this.widget.mediaIdSelected = id;
    });
    MainPageState.changeMusicActie(widget.items[id]);
    MainPageState.setCommand(Command.play);
    /*
    setState(() {
      miniplayer.music = widget.items[id];
    });
    if (!miniplayer.playing)
      setState(() {
        miniplayer.command = "PLAY";
      });
    */
    //reproduz midia
  }

  @override
  void initState() {
    if (MainPageState.musicPlaying != null) {
      for (Media item in widget.items) {
        print ((item as MusicModel) == MainPageState.musicPlaying);
        if (item.runtimeType == MusicModel && (item as MusicModel) == MainPageState.musicPlaying)
          setState(() {
            widget.mediaIdSelected = widget.items.indexOf(item);
          });
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MusicModel midiaSelected = widget.mediaIdSelected != -1 && widget.items[widget.mediaIdSelected].runtimeType == MusicModel? widget.items[widget.mediaIdSelected] : null;
    
    return Expanded (
      child: Column (
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (BuildContext ctxt, int i) {
                return Column(
                  children: <Widget>[
                    ItemViewLine(widget.items[i], i==widget.mediaIdSelected, this.tapeMedia, i),
                    Divider(
                      color: Colors.white.withOpacity(0.5),
                      indent: 15,
                      endIndent: 15,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}