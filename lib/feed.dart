import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaglone/Post.dart';
import 'package:instaglone/main.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String current_user = "";
  List<dynamic> following = [];

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      current_user = user.uid;
      FirebaseFirestore.instance
          .collection("Users")
          .doc(current_user)
          .get()
          .then((value) => value.data())
          .then((value) => setState(() {
                following = value?["following"];
              }))
          .catchError((err) => print(err));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(following);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Instaglone",
          style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w500,
              fontFamily: "Billabong"),
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .orderBy("createdOn", descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
                Post(snapshot: snapshot.data!.docs[index].data()),
          );
        },
      ),
    );
  }
}
