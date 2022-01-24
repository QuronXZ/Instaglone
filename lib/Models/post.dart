import 'dart:io';
import 'dart:convert';

class Post {
  File pic;
  String caption;
  List likedBy = [];
  String createdOn;
  String owner;

  Post(
      {required this.pic,
      required this.caption,
      required this.owner,
      required this.createdOn});

  Post.fromJson(Map<String, Object?> json)
      : this(
            pic: File(base64Decode(json['pic'].toString()).toString()),
            caption: json['catpion'].toString(),
            owner: json['owner'].toString(),
            createdOn: json['createdOn'].toString());

  Map<String, Object> toJson() {
    return {
      'pic': base64Encode(pic.readAsBytesSync()),
      'caption': caption,
      'likedBy': likedBy,
      'createdOn': createdOn,
      'owner': owner
    };
  }
}
