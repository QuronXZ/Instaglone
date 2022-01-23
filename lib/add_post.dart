import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'post_preview.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  void _openCamera(BuildContext context) async {
    XFile? picture = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picture != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PhotoPreviewScreen(File(picture.path))));
    }
  }

  void _openGallery(BuildContext context) async {
    XFile? picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picture != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PhotoPreviewScreen(File(picture.path))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                fontFamily: "Billabong")),
      ),
      body: Column(
        children: [
          Expanded(
            child: InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.camera_alt_outlined),
                    Text("Take a photo")
                  ],
                ),
              ),
              onTap: () => {_openCamera(context)},
            ),
          ),
          Expanded(
            child: InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.image),
                    Text("Select from Gallery")
                  ],
                ),
              ),
              onTap: () => {_openGallery(context)},
            ),
          )
        ],
      ),
    );
  }
}
