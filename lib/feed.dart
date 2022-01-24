import 'package:flutter/material.dart';
import 'package:instaglone/Post.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        children: [Post(), Post(), Post()],
      ),
    );
  }
}
