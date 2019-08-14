import 'package:flutter/cupertino.dart';

import './media.dart';

class MusicModel implements Media {
  num id;
  num duration;
  String pathFile;
  String title;
  String style;
  String author;
  
  @override
  bool operator ==(other) {
    return toString() == other.toString();
  }

  MusicModel({this.id, this.duration, this.pathFile, this.title, this.style, this.author});

  MusicModel.fromJson(Map <String, dynamic> json) {
    this.id = json['id'];
    this.duration = json['duration'];
    this.pathFile = json['pathFile'];
    this.title = json['title'];
    this.style = json['style'];
    this.author = json['author'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['duration'] = this.duration;
    data['pathFile'] = this.pathFile;
    data['title'] = this.title;
    data['style'] = this.style;
    data['author'] = this.author;
    return data;
  }

  @override
  String toString() {
    return this.title+this.author+this.id.toString();
  }
}