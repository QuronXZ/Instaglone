import 'package:flutter/material.dart';

void ShowSnack(BuildContext context, String msg) {
  SnackBar msg = new SnackBar(content: Text("Sign-Up successful!"));
  ScaffoldMessenger.of(context).showSnackBar(msg);
}
