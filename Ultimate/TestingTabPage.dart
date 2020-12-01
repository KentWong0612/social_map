import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Firebase/MapEventProviderFS.dart';
import 'package:image_picker/image_picker.dart';

class TestingTabPage extends StatefulWidget {
  @override
  _TestingTabPageState createState() => _TestingTabPageState();
}

class _TestingTabPageState extends State<TestingTabPage> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Picker: No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventTableDBFS = context.watch<EventTableFromDBFS>();
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: _image == null
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: getImage,
              )
            : Image.file(_image),
      ),
    );
  }
}
