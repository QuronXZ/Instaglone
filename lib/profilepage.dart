import 'dart:html';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaglone/Models/showSnackbar.dart';
import 'widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var userData ={};

  @override
  void initState(){
    super.initState();
    getData();
  }

  getData() async{
    try{
      var snap = await FirebaseFirestore.instance.collection('Users').doc(widget.uid).get();
      userData = snap.data()!;
      setState(() {
        
      });
      
    }
    catch(e){
      ShowSnack(context, e.toString(),);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text(userData['username'],),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1643056205382-779bfbe21a8b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                    ),
                    radius: 40,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildStatColumn(20, "Posts"),
                            buildStatColumn(150, "Followers"),
                            buildStatColumn(11, "Following"),
                        ],
                        
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FollowButton(
                              text: 'Edit Profile',
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              borderColor: Colors.grey,
                              function: () {},

                      )
                    ],
                  ),
                      ],
                    ),           
                  ),
                  

                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top:15,),
                child: Text(
                  'username',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top:1,),
                child: Text(
                  'some description',
                ),
              )
            ],
          ),
        ),
        const Divider(),
      ],
    ),
  );
  }
  Column buildStatColumn(int num, String label){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
