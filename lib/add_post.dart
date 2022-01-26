import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'post_preview.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  void _openCamera(BuildContext context) async {
    try {
      XFile? picture = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 75);
      if (picture != null) {
        File? image = await ImageCropper.cropImage(
            sourcePath: picture.path,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
        if (image != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PhotoPreviewScreen(File(image.path))));
        }
      }
    } catch (src, trace) {
      Fluttertoast.showToast(
          msg: "Image picker already running", toastLength: Toast.LENGTH_LONG);
    }
  }

  void _openGallery(BuildContext context) async {
    try {
      XFile? picture = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (picture != null) {
        File? image = await ImageCropper.cropImage(
            sourcePath: picture.path,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
        if (image != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PhotoPreviewScreen(File(image.path))));
        }
      }
    } catch (src, trace) {
      Fluttertoast.showToast(
          msg: "Image picker already running", toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create Post",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                fontFamily: "Billabong")),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 75,
                    ),
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
                    Icon(
                      Icons.image,
                      size: 75,
                    ),
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
