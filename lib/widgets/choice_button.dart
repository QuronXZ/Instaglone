import 'dart:js';

import 'package:flutter/material.dart';
import 'package:instaglone/changePassword.dart';

class Choice {
  Choice({required this.name});
  final String name;
}

final List<Choice> choices = <Choice>[
  Choice(
    name: 'Change Password',
  ),
  Choice(
    name: 'LogOut',
  ),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key? key, required this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.headline1;
    return Card(
      color: Colors.greenAccent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                child: Text(choice.name, style: textStyle),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChangePass()));
                })
          ],
        ),
      ),
    );
  }
}
