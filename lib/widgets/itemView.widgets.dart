import 'package:flutter/material.dart';
import 'package:music_app/models/lyrics.dart';
import 'package:music_app/models/media.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/models/partiture.dart';
import 'package:music_app/models/tab.dart';

class ItemViewExtended extends StatefulWidget {
  final sideImageSizeHeight = 88.0;
  final sideImageSizeWidth = 90.0;
  final contentWidth = 100.0;
  final infoColor = Colors.white;
  Media item;

  ItemViewExtended(itemLoad) {
    this.item = itemLoad;
  }

  @override
  _ItemViewExtendedState createState() => _ItemViewExtendedState();
}

class _ItemViewExtendedState extends State<ItemViewExtended> {
  @override
  Widget build(BuildContext context) {
    var itemTyped = widget.item;
    if (itemTyped.runtimeType == MusicModel) {
      return Container (
        width: widget.contentWidth,
        //color: Colors.deepOrange,
        child: Column (
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.05, 1],
                  colors: [
                    Colors.pink,
                    Colors.deepOrange,
                  ]
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5)
                ),
              ),
              width: widget.sideImageSizeWidth,
              height: widget.sideImageSizeHeight,
              child: Icon(
                Icons.headset,
                color: widget.infoColor,
              ),
            ),
            Text((itemTyped as MusicModel).title,
              style: TextStyle(
                color: widget.infoColor
              ),
            ),
            Text(
              "by "+(itemTyped as MusicModel).author,
              style: TextStyle(
                color: widget.infoColor
              ),
            ),
          ],
        ),
      );
    } else if (itemTyped.runtimeType == LyricsModel) {
      return Container (
        width: widget.contentWidth,
        //color: Colors.deepOrange,
        child: Column (
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.05, 1],
                  colors: [
                    Colors.pink,
                    Colors.deepOrange,
                  ]
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5)
                ),
              ),
              width: widget.sideImageSizeWidth,
              height: widget.sideImageSizeHeight,
              child: Icon(
                Icons.library_books,
                color: widget.infoColor,
              ),
            ),
            Text((itemTyped as LyricsModel).title,
              style: TextStyle(
                color: widget.infoColor
              ),
            ),
            Text(
              "by "+(itemTyped as LyricsModel).author,
              style: TextStyle(
                color: widget.infoColor
              ),
            ),
          ],
        ),
      );
    } else if (itemTyped.runtimeType == PartitureModel) {
      return Container (
        width: widget.contentWidth,
        //color: Colors.deepOrange,
        child: Column (
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.05, 1],
                  colors: [
                    Colors.pink,
                    Colors.deepOrange,
                  ]
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5)
                ),
              ),
              width: widget.sideImageSizeWidth,
              height: widget.sideImageSizeHeight,
              child: Icon(
                Icons.music_note,
                color: widget.infoColor,
              ),
            ),
            Text((itemTyped as PartitureModel).title,
              style: TextStyle(
                color: widget.infoColor
              ),
            ),
            Text(
              "by "+(itemTyped as PartitureModel).author,
              style: TextStyle(
                color: widget.infoColor
              ),
            ),
          ],
        ),
      );
    } else if (itemTyped.runtimeType == TabModel) {
      Container (
        width: widget.contentWidth,
        //color: Colors.deepOrange,
        child: Column (
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.05, 1],
                  colors: [
                    Colors.pink,
                    Colors.deepOrange,
                  ]
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5)
                ),
              ),
              width: widget.sideImageSizeWidth,
              height: widget.sideImageSizeHeight,
              child: Icon(
                Icons.queue_music,
                color: widget.infoColor,
              ),
            ),
            Text((itemTyped as TabModel).title,
              style: TextStyle(
                color: widget.infoColor
              ),
            ),
            Text(
              "by "+(itemTyped as TabModel).author,
              style: TextStyle(
                color: widget.infoColor
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      
    );
  }
}