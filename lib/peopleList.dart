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
  User? user = FirebaseAuth.instance.currentUser;
  List<String> DocList = [];

  void getdata() {
    String id = user!.uid;
    FirebaseFirestore.instance.collection("Users").doc(id).get().then((value) {
      Map<String, dynamic>? info = value.data();
      if (info != null) {
        // first add the data to the Offset object
        setState(() {
          List.castFrom(info["followers"]).forEach((element) {
            // print(element);
            DocList.add(element.toString());
          });
        });
      }
    });
  }

  void peopleAdd(Map<String, dynamic>? data) {
    u.User usr = new u.User(username: data!['username'], name: data['name']);
    print(usr.username);
    setState(() {
      usrList.add(usr);
    });
  }

  @override
  Widget build(BuildContext context) {
    getdata();
    DocList.forEach((element) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(element)
          .get()
          .then((value) => peopleAdd(value.data()));
    });
    print(usrList);
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
