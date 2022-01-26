// ignore_for_file: prefer_const_constructors
// import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'Material_color_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PhotoPreviewScreen extends StatefulWidget {
  File imageFile;
  PhotoPreviewScreen(this.imageFile);
  @override
  _PhotoPreviewScreenState createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  final TextEditingController controller = new TextEditingController();

  //Method to render image on screen
  Widget _setImageView() {
    if (widget.imageFile != null) {
      return Image.file(widget.imageFile, width: 500, height: 500);
    } else {
      return Text("Please select an image");
    }
  }

  // Method to handle backbutton
  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Discard changes?'),
            content: Text('There are unsaved changes.'),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text("NO"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Text("YES"),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  //Method to save post
  Future<void> _savePost() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //Getting the current user ID
      String owner = user.uid;
      //Getting collection reference from database
      final moviesRef = FirebaseFirestore.instance.collection('Posts');

      final newpath = p.join((await getTemporaryDirectory()).path,
          '${DateTime.now()}.${p.extension(widget.imageFile.path)}');
      final result = await FlutterImageCompress.compressAndGetFile(
          widget.imageFile.path, newpath,
          quality: 75);
      if (result != null) {
        final ref = FirebaseStorage.instance.ref().child("post").child(
            '${DateTime.now().toIso8601String() + p.basename(result.path)}');
        final res = await ref.putFile(result);
        final url = await res.ref.getDownloadURL();
        try {
          await moviesRef.add({
            'pic': url.toString(),
            'caption': controller.text,
            'likedBy': [],
            'createdOn': DateTime.now().toString(),
            'owner': owner
          });
          //On post creation
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "Post created!!", toastLength: Toast.LENGTH_SHORT);
        } on Exception catch (e) {
          Fluttertoast.showToast(
              msg: e.toString(), toastLength: Toast.LENGTH_LONG);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Preview"),
            elevation: 0,
          ),
          body: Center(
            child: ListView(
              children: <Widget>[
                _setImageView(),
                TextField(
                  controller: this.controller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.text_snippet_outlined),
                    labelText: "Caption",
                    hintText: "\n\n\n\n\n",
                    prefixIconColor: Colors.black,
                    focusColor: Colors.black,
                    iconColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check),
            onPressed: _savePost,
          ),
        ),
        onWillPop: _onBackPressed);
  }
}
