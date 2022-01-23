import 'package:flutter/material.dart';
import "Material_color_generator.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String name = "";
    firestore
        .collection('users')
        .doc("GZtGoQTDsgPwSTeoevCx")
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        print('Document exists on the database');
        var data = doc.data();
        name = data.toString();
      }
    });
    return MaterialApp(
      title: 'Feed',
      theme: ThemeData(primarySwatch: generateMaterialColor(Colors.white)),
      home: MyHomePage(name),
    );
  }
}

class MyHomePage extends StatelessWidget {
  String text;
  MyHomePage(this.text);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instaglone"),
      ),
      body: Center(
        child: Text(text),
      ),
    );
  }
}
