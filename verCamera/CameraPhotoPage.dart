import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPhotoScreen extends StatefulWidget {
  List<String> listOfPath;
  CameraPhotoScreen(this.listOfPath);

  @override
  _CameraScreenPhotoState createState() => _CameraScreenPhotoState();
}

class _CameraScreenPhotoState extends State<CameraPhotoScreen> {
  List<CameraDescription> _cameraList;
  CameraDescription firstCamera;
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _obtainCamera();
  }

  Future<void> _obtainCamera() async {
    _cameraList = await availableCameras();
    firstCamera = await _cameraList.first;
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      firstCamera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    return _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
    debugPrint('camera dispose is called');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              debugPrint('done');
              if (_initializeControllerFuture == null) {
                debugPrint('it is in done, controller = null');
              } else {
                debugPrint('it is in done, controller != null');
              }
              return CameraPreview(_controller);
            } else {
              // Otherwise, display a loading indicator.
              debugPrint('not done');
              if (_initializeControllerFuture == null) {
                debugPrint('it is in not done, controller = null');
              } else {
                debugPrint('it is in not done, controller != null');
              }
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 50, left: 20),
        child: Align(
          alignment: Alignment.topLeft,
          child: FloatingActionButton(
            heroTag: 'cancel',
            backgroundColor: Colors.red,
            child: Icon(
              Icons.cancel,
            ),
            // Provide an onPressed callback.
            onPressed: () async {
              Navigator.pop(context, null);
            },
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          heroTag: 'take photo',
          child: Icon(Icons.camera_alt),
          // Provide an onPressed callback.
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final path = join(
                // Store the picture in the temp directory.
                // Find the temp directory using the `path_provider` plugin.
                (await getExternalStorageDirectory()).path,
                '${DateTime.now()}.png',
              );
              await _controller.takePicture(path);
              widget.listOfPath.add(path);
              Navigator.pop(context, path);
            } catch (e) {
              print(e);
            }
          },
        ),
      )
    ]);
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
