import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Models/user.dart';

class FollowList extends StatefulWidget {
  final String uid;
  const FollowList({Key? key, required this.uid}) : super(key: key);

  @override
  _FollowListState createState() => _FollowListState();
}

class _FollowListState extends State<FollowList> {
  final List<User> usrlist = [];
  Future<void> getList(String uid) async {
    var _firestore = FirebaseFirestore.instance;
    DocumentSnapshot snap = await _firestore.collection('Users').doc(uid).get();
    List following = (snap.data()! as dynamic)['followers'];

    following.forEach((element) async {
      DocumentSnapshot docsnap =
          await _firestore.collection('Users').doc(element).get();
      User usr = new User(
          username: docsnap['username'],
          name: docsnap['name'],
          bio: docsnap['bio'],
          dob: docsnap['dob'],
          email: docsnap['email'],
          followers: docsnap['followers'],
          following: docsnap['following'],
          password: docsnap['password']);
      print(usr.username);
      usrlist.add(usr);
    });
  }

  @override
  Widget build(BuildContext context) {
    getList(widget.uid);
    return Scaffold(
        appBar: AppBar(
          title: Text("Followers"),
        ),
        body: ListView.builder(
            itemCount: usrlist.length,
            itemBuilder: (context, index) {
              final User data = usrlist[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${data.name}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, left: 8.0, right: 8.0),
                    child: Text('${data.username}',
                        style: Theme.of(context).textTheme.bodyText1),
                  )
                ],
              );
            }));
  }
}
