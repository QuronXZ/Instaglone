import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final snapshot;
  const Post({Key? key, required this.snapshot}) : super(key: key);

  @override
  _PostState createState() => _PostState(snapshot);
}

class _PostState extends State<Post> {
  final snap;
  _PostState(this.snap);

// Variables
  Icon fav_icon = Icon(
    Icons.favorite_border,
    size: 32,
  );
  bool isLiked = false;

// On like Function
  void on_like() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        fav_icon = Icon(
          Icons.favorite,
          size: 32,
          color: Colors.red,
        );
        snap["likedBy"].add("Current User");
        FirebaseFirestore.instance
            .collection('Posts')
            .where("createdOn", isEqualTo: snap["createdOn"])
            .where("owner", isEqualTo: snap["owner"])
            .get()
            .then((value) => FirebaseFirestore.instance
                .collection('Posts')
                .doc(value.docs.first.id)
                .update({"likedBy": snap["likedBy"]}));
      } else {
        fav_icon = Icon(
          Icons.favorite_border,
          size: 32,
        );
        snap["likedBy"].remove("Current User");
        FirebaseFirestore.instance
            .collection('Posts')
            .where("createdOn", isEqualTo: snap["createdOn"])
            .where("owner", isEqualTo: snap["owner"])
            .get()
            .then((value) => FirebaseFirestore.instance
                .collection('Posts')
                .doc(value.docs.first.id)
                .update({"likedBy": snap["likedBy"]}));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.amber,
                ),
                SizedBox(width: 10),
                Text(
                  snap["owner"],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: Image.memory(base64Decode(snap["pic"])),
            color: Colors.black,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => on_like(),
                icon: fav_icon,
              ),
              InkWell(
                onLongPress: () => {},
                child: Text(
                  snap["likedBy"].length.toString() + " likes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 10),
              Text(
                snap["owner"],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  snap["caption"],
                  style: TextStyle(fontSize: 14),
                  maxLines: 15,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
