import 'package:flutter/material.dart';
import 'package:instaglone/profilepage.dart';

class Choice {
  Choice({required this.name});
  final String name;
}

/* final List<Choice> choices = <Choice>[
  Choice(
    name: 'Change Password',
  ),
  Choice(
    name: 'LogOut',
  ),
]; */

class ChoiceCard extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
/*   final Function()? function;
  const ChoiceCard({Key? key, required this.choice, this.function}) : super(key: key);

  final Choice choice;*/

  @override
  Widget build(BuildContext context) {
    return ChoiceCard();
  }
}
