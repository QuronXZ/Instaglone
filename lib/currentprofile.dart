import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profilepage.dart';

class CurrentProfile extends StatefulWidget {
  const CurrentProfile({Key? key}) : super(key: key);

  @override
  _CurrentProfileState createState() => _CurrentProfileState();
}

class _CurrentProfileState extends State<CurrentProfile> {
  String profileUID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(uid: profileUID);
  }
}
