import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profilepage.dart';

class CurrentProfile extends StatefulWidget {
  const CurrentProfile({Key? key}) : super(key: key);

  @override
  _CurrentProfileState createState() => _CurrentProfileState();
}

class _CurrentProfileState extends State<CurrentProfile> {
  String profileUID = "";

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      profileUID = user.uid;
    }
    return ProfileScreen(uid: profileUID);
  }
}
