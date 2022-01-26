import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class listPeople extends StatefulWidget {
   final String uid;
  const listPeople({Key? key, required this.uid}) : super(key: key);
  @override
  _listPeopleState createState() => _listPeopleState();
}

class _listPeopleState extends State<listPeople> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Users').snapshots();
  final usersRef = FirebaseFirestore.instance.collection('Users').snapshots();
  bool isShowUsers = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Followers"),
        ),
        body: isShowUsers
            ? StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ));
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic)
                        .docs
                        .uid['followers']
                        .length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: ListTile(
                          // leading: CircleAvatar(
                          //   backgroundImage: NetworkImage(
                          //     (snapshot.data! as dynamic).docs[index]
                          //         ['photoUrl'],
                          //   ),
                          //   radius: 16,
                          // ),
                          title: Text(
                            (snapshot.data! as dynamic).docs.uid['followers']
                                [index],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            : Center(
                child: Text(
                  'No followers :(',
                  textAlign: TextAlign.center,
                ),
              ));
  }
}
