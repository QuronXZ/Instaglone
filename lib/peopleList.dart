import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaglone/Models/user.dart';

class listPeople extends StatefulWidget {
  //const listPeople({Key? key}) : super(key: key);
  final List<User> listItems = [];
  @override
  _listPeopleState createState() => _listPeopleState();
}

class _listPeopleState extends State<listPeople> {
  bool isShowUsers = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Followers"),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .where('followers', arrayContains: true)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
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
                            (snapshot.data! as dynamic).docs[index]['username'],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            : Text("No followers :("));
  }
}
