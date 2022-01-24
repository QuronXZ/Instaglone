// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'Material_color_generator.dart';

class PhotoPreviewScreen extends StatefulWidget {
  File imageFile;
  PhotoPreviewScreen(this.imageFile);
  @override
  _PhotoPreviewScreenState createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  final TextEditingController controller = new TextEditingController();

  Widget _setImageView() {
    if (widget.imageFile != null) {
      return Image.file(widget.imageFile, width: 500, height: 500);
    } else {
      return Text("Please select an image");
    }
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Discard changes?'),
            content: Text('There are unsaved changes.'),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _savePost() {}

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
                      focusColor: generateMaterialColor(Colors.black)),
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
