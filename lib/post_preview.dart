import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PhotoPreviewScreen extends StatefulWidget {
  File imageFile;
  PhotoPreviewScreen(this.imageFile);
  @override
  _PhotoPreviewScreenState createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  Widget _setImageView() {
    if (widget.imageFile != null) {
      return Image.file(widget.imageFile, width: 500, height: 500);
    } else {
      return Text("Please select an image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_setImageView()],
        ),
      ),
    );
  }
}
