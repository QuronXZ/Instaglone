import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:instaglone/Models/showSnackbar.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  //Declaring variables
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController username = new TextEditingController();

  //Method to register user in firebase
  void _register() async {
    try {
      //showing loading widget
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.ring
        ..backgroundColor = Color.fromRGBO(255, 255, 255, 0.1)
        ..indicatorColor = Color.fromRGBO(0, 0, 0, 1);
      EasyLoading.show(status: "Please wait");
      //creating user in firebase auth
      User? user = (await _auth.createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim()))
          .user;
      //storing user in firestore after successful authentication
      if (user != null) {
        final usersRef = FirebaseFirestore.instance.collection('Users');
        //getting reference of default profile pic
        final ref = await FirebaseStorage.instance
            .ref()
            .child("profile.png")
            .getDownloadURL();
        //storing data in firestore
        usersRef
            .doc(user.uid)
            .set({
              "name": "",
              "dob": "",
              "followers": [],
              "following": [],
              "username": username.text.trim(),
              "bio": "",
              "profile": ref.toString()
            })
            .then((value) => ShowSnack(context, "Sign-Up Successful!!"))
            .then((value) => EasyLoading.dismiss())
            .then((value) => Navigator.pop(context))
            .catchError((err) => ShowSnack(
                context, err.message ?? "There's some error in our database!"));
      }
    } on FirebaseAuthException catch (e) {
      ShowSnack(context, e.message ?? "There's some error in our server!");
    }
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    username.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 30),
              child: Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(color: Colors.white),
                            controller: username,
                            decoration: InputDecoration(
                                labelText: 'Username',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.grey.shade800),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.green),
                                  borderRadius: BorderRadius.circular(15),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            controller: email,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.grey.shade800),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.green),
                                  borderRadius: BorderRadius.circular(15),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            obscureText: true,
                            controller: password,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.grey.shade800),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.green),
                                  borderRadius: BorderRadius.circular(15),
                                )),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: _register,
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
