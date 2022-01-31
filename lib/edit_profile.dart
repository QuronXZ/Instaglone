import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaglone/profilepage.dart';

import 'currentprofile.dart';


class EditProfile extends StatefulWidget {
  final String uid;
  const EditProfile({ Key? key, required this.uid }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  late String _imageFile;
  final ImagePicker _picker = ImagePicker();
  

  final _formKey = GlobalKey<FormState>();

  //Updating user
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  Future<void> updateUser(uid, name, bio, dob, username){
    return users
       .doc(uid)
       .update({'name':name, 'bio':bio, 'dob':dob, 'username':username})
       .then((value) => print('User Updated'))
       .catchError((error) => print('Failed to update user: $error'));
       
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
        backgroundColor: Colors.grey[50],
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
          onPressed: () {
            gotoSecondActivity(context);
          },
        ),
      ),
      body: Form(
          key: _formKey,
          // Getting Specific Data by ID
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('Users')
                .doc(widget.uid)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                print('Something Went Wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var data = snapshot.data!.data();
              var name = data!['name'];
              var username = data['username'];
              var bio = data['bio'];
              var dob = data['dob'];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2, blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0,10)
                            )
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/profile.png'),                            
                            // image: _imageFile==null ? AssetImage('assets/profile.png') : Image.network(_imageFile);
                          )
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet()),
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Colors.green,
                            ),
                            child: Icon(Icons.edit, color: Colors.white,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 35),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: name,
                        autofocus: false,
                        onChanged: (value) => name = value,
                        decoration: InputDecoration(
                          labelText: 'Name: ',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 3, color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0)
                          ),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: username,
                        autofocus: false,
                        onChanged: (value) => username = value,
                        decoration: InputDecoration(
                          labelText: 'Username: ',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 3, color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0)
                          ),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Username';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: dob,
                        autofocus: false,
                        onChanged: (value) => dob = value,
                        decoration: InputDecoration(
                          labelText: 'Birth Date: ',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 3, color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0)
                          ),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter bithdate';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: bio,
                        autofocus: false,
                        onChanged: (value) => bio = value,
                        decoration: InputDecoration(
                          labelText: 'Bio: ',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 3, color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0)
                          ),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter bio';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState!.validate()) {
                                updateUser(widget.uid, name, bio, dob, username);
                                // Navigator.pop(context);
                              }
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () => {
                              gotoSecondActivity(context)
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget imageProfie() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: AssetImage('assets/profile.png'),
        )
      ],
    );
  }

  Widget bottomSheet() {
                  return Container(
                    height: 100.0,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Choose profile photo",
                          style: TextStyle(
                          fontSize : 20.0,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton.icon(
                              icon: Icon(Icons.camera),
                              onPressed: () {
                                takePhoto(ImageSource.camera);
                              },
                              label: Text("Camera"),
                            ),
                            FlatButton.icon(
                              icon: Icon(Icons.image),
                              onPressed: () {
                                takePhoto(ImageSource.gallery);
                              },
                              label: Text("Gallery"),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }
  void takePhoto(ImageSource source)async{
    final PickedFile = await _picker.pickImage(
      source: source,
      );
    setState(() {
      _imageFile = uploadImage(PickedFile!) as String;
    });
  }

  Future<String> uploadImage(XFile image) async{
  Reference db = FirebaseStorage.instance.ref("ProfileImage/");
  await db.putFile(File(image.path));
  return await db.getDownloadURL();
}

gotoSecondActivity(BuildContext context){
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CurrentProfile()),
    );
    
  }

//Returns img name
// String getImageName(XFile image){
//   return image.path.split("/").last;
// }
}


