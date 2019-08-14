import 'package:flutter/material.dart';
import 'package:music_app/models/lyrics.dart';
import 'package:music_app/models/media.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/models/partiture.dart';
import 'package:music_app/models/tab.dart';

class ItemViewLine extends StatelessWidget {

  final itemHeight = 50.0;
  final titleFontSize = 15.0;
  final authorFontSize = 5.0;

  Media item;
  Color itemColor;
  Function onClick;
  int idx;

  ItemViewLine(_item, _isplaying, _onClick, _idx) {
    this.item = _item;
    if (_isplaying)
      this.itemColor = Colors.deepOrange;
    else
      this.itemColor = Colors.white;
    this.onClick = _onClick;
    this.idx = _idx;
  }

  @override
  Widget build(BuildContext context) {
    var itemTyped = item;
    if (itemTyped.runtimeType == MusicModel) {
      
      return Container (
        height: itemHeight,
        child: FlatButton(
          onPressed: () => onClick(idx),
          child: Row (
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row (
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon (
                    Icons.headset,
                    color: itemColor,
                  ),
                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text (
                        (item as MusicModel).title,
                        style: TextStyle(
                          color: itemColor,
                          fontSize: titleFontSize,
                        ),
                      ),
                      Text (
                        (item as MusicModel).author,
                        style: TextStyle(
                          color: itemColor.withOpacity(0.7),
                          fontSize: titleFontSize,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.more_vert,
                color: itemColor,
              ),
            ],
          ),
        ),
      );
    } else if (itemTyped.runtimeType == LyricsModel) {
      return Container (
        
      );
    } else if (itemTyped.runtimeType == PartitureModel) {
      return Container (
        
      );
    } else if (itemTyped.runtimeType == TabModel) {
      return Container (
        
      );
    }
    return SizedBox.expand(
      
    );
  }
}