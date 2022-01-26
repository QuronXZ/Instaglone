import 'package:flutter/material.dart';

void ShowSnack(BuildContext context, String msg) {
  SnackBar snack = new SnackBar(content: Text(msg));
  ScaffoldMessenger.of(context).showSnackBar(snack);
}
