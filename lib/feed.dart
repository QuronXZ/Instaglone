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

  void set_following(Map<String, dynamic>? user_data) {
    if (mounted == true) {
      setState(() {
        following = user_data?["following"];
      });
    }
  }

  void get_following() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(current_user)
        .get()
        .then((value) => {set_following(value.data())});
  }

  @override
  void initState() {
    super.initState();
    if (mounted == true) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        current_user = user.uid;
      }
      get_following();
      if (following.length == 0) {
        setState(() {
          following = [current_user];
        });
      }
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data?.docs == []) {
            return Center(
              child: Text(
                "Your Friends haven't posted anything, Yet!",
                style: TextStyle(fontSize: 32),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Post(
              snapshot: snapshot.data!.docs[index].data(),
              following: following,
            ),
          );
        },
      ),
    );
  }
}
