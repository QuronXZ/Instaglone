import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaglone/Models/user.dart' as u;

class listPeople extends StatefulWidget {
  const listPeople({Key? key}) : super(key: key);
  @override
  _listPeopleState createState() => _listPeopleState();
}

class _listPeopleState extends State<listPeople> {
  final List<u.User> usrList = [];
  List<String> getdata() {
    List<String> folList = [];
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      // first add the data to the Offset object
      List.castFrom(value["followers"]).forEach((element) {
        folList.add(element.toString());
      });
    });
    return folList;
  }

  void peopleAdd(Map<String, dynamic>? data) {
    u.User usr = new u.User(username: data!['username'], name: data['name']);
    setState(() {
      usrList.add(usr);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> DocList = getdata();
    DocList.forEach((element) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(element)
          .get()
          .then((value) =>  peopleAdd(value.data()));
    });
    return Scaffold(
        appBar: AppBar(
          title: Text("Followers"),
        ),
        body: ListView.builder(
          itemCount: DocList.length,
          itemBuilder: (context, index) {
            final u.User data = usrList[index];
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
                  padding:
                      const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                  child: Text('${data.username}',
                      style: Theme.of(context).textTheme.bodyText1),
                )
              ],
            );
          },
        ));
  }
}
