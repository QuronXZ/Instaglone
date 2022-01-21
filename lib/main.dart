import 'package:flutter/material.dart';
import "Material_color_generator.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed',
      theme: ThemeData(primarySwatch: generateMaterialColor(Colors.white)),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Instaglone"),
        ),
        body: Center(
            child: Text(
                "Hello user")) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
