import './media.dart';

class TabModel implements Media {
  num id;
  String pathFile;
  String title;
  String author;

  TabModel({this.id ,this.pathFile, this.title, this.author});

  TabModel.fromJson(Map <String, dynamic> json) {
    this.id = json['id'];
    this.pathFile = json['pathFile'];
    this.title = json['title'];
    this.author = json['author'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pathFile'] = this.pathFile;
    data['title'] = this.title;
    data['author'] = this.author;
    return data;
  }
}