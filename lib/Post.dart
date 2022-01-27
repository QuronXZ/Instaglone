import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String current_user = "";
  bool isLiked = false;
  String post_owner = "";
  String post_prof = "";

  void set_owner(Map<String, dynamic>? post_data) {
    setState(() {
      post_owner = post_data?["username"];
      post_prof = post_data?["profile"];
    });
  }

  void get_owner() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(snap["owner"])
        .get()
        .then((value) => {set_owner(value.data())});
  }

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
        snap["likedBy"].add(current_user);
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
        snap["likedBy"].remove(current_user);
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
      isLiked = snap["likedBy"].contains(current_user);
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      current_user = user.uid;
      isLiked = snap["likedBy"].contains(current_user);
    }
    get_owner();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Row(
              children: [
                CircleAvatar(
                  child: Image.network(
                    post_prof,
                    errorBuilder: (context, error, stackTrace) => Text("..."),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  post_owner,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              (snap["pic"]),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              },
              errorBuilder: (context, exception, stackTrace) {
                return Center(child: Text("Loading.."));
              },
            ),
            color: Colors.black,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => on_like(),
                icon: isLiked
                    ? Icon(
                        Icons.favorite,
                        size: 32,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.favorite_border,
                        size: 32,
                      ),
              ),
              InkWell(
                onTap: () => {},
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
                post_owner,
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
