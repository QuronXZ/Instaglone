import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instaglone/changePassword.dart';
import 'package:instaglone/peopleList.dart';
import "Material_color_generator.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..textColor = Color.fromRGBO(0, 0, 0, 1.0)
      ..indicatorColor = Color.fromRGBO(0, 0, 0, 1.0)
      ..backgroundColor = Color.fromRGBO(255, 255, 255, 0.7)
      ..loadingStyle = EasyLoadingStyle.custom;
    // signout();
  }

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instaglone',
      theme: ThemeData(
          primarySwatch: generateMaterialColor(Colors.black),
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white, foregroundColor: Colors.black),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.white, foregroundColor: Colors.black)),
      routes: {
        "home": (context) => MyHomePage(),
        "login": (context) => MyLogin(),
        "register": (context) => MyRegister(),
        "/changePass": (context) => ChangePass(),
        // "people":(context)=>listPeople()
      },
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? "login" : "home",
      home: MyHomePage(),
      builder: EasyLoading.init(),
    );
  }
}
