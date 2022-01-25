import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import "Material_color_generator.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'Nav.dart';
import 'login.dart';
import 'register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> user;

  void initState() {
    super.initState();
    signout();
    // user = FirebaseAuth.instance.authStateChanges().listen((user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //   }
    // });
  }

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instaglone',
      theme: ThemeData(primarySwatch: generateMaterialColor(Colors.white)),
      routes: {
        "home": (context) => MyHomePage(),
        "login": (context) => MyLogin(),
        "register": (context) => MyRegister(),
      },
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? "login" : "home",
      home: MyHomePage(),
    );
  }
}
