import 'package:flutter/material.dart';

class User {
  String username = '';
  String name = '';
  bool isfollowing = true;

  User(this.username, this.name);
  void following() {
    isfollowing = !isfollowing;
    if (isfollowing) {
      Colors.amber;
    } else {
      Colors.black;
    }
  }
}

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<User> users = [];
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
