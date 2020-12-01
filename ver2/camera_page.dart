import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
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
      FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () {},
      )
    ]);
  }
}
