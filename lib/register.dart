import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "Already Clicked", toastLength: Toast.LENGTH_SHORT);
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                              'sign in',
                              style: TextStyle(
                                color: Color(0xff4c505b),
                                fontSize: 27,
                                fontWeight: FontWeight.w700
                              ),
                              ),
                            ],
                          ),
                    SizedBox(height: 30),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            controller: username,
                            decoration: buildInputDecoration(Icons.person, "Username"),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            controller: email,
                            decoration: buildInputDecoration(Icons.mail, "Email"),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            obscureText: true,
                            controller: password,
                            decoration: buildInputDecoration(Icons.lock, "Password"),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed:_register,
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

InputDecoration buildInputDecoration(IconData icons,String hinttext) {
  return InputDecoration(
    hintText: hinttext,
    prefixIcon: Icon(icons),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(
          color: Colors.green,
          width: 1.5
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 1.5,
      ),
    ),
    enabledBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 1.5,
      ),
    ),
  );
}
