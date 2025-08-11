import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FaceCaptureScreen extends StatefulWidget {
  @override
  _FaceCaptureScreenState createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  int _step = 0;
  List<File> _capturedImages = [];
  final List<String> _steps = ['Front', 'Left', 'Right', 'Up', 'Down'];

  @override
  void initState() {
    _faceDetector = FaceDetector(options: FaceDetectorOptions());
    _initializeCamera();
    super.initState();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[1], ResolutionPreset.medium);
    await _cameraController.initialize();
    _startFaceDetection();
    setState(() {});
  }

  void _startFaceDetection() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      if (!_cameraController.value.isInitialized || _isDetecting) return;
      _isDetecting = true;

      try {
        final image = await _cameraController.takePicture();
        final inputImage = InputImage.fromFilePath(image.path);
        final faces = await _faceDetector.processImage(inputImage);

        if (faces.isNotEmpty) {
          _capturedImages.add(File(image.path));
          if (_step < _steps.length - 1) {
            _step++;
          } else {
            timer.cancel();
            _uploadImages();
          }
        } else {
          File(image.path).delete();
        }
      } catch (e) {
        print("Error: $e");
      }

      _isDetecting = false;
      setState(() {});
    });
  }

  Future<void> _uploadImages() async {
    // Your API logic here
    print("Uploading ${_capturedImages.length} images...");
  }

  // Future<void> _uploadImages() async {
  //   var request = http.MultipartRequest('POST', Uri.parse('https://your-api-url/upload'));
  //   for (int i = 0; i < _capturedImages.length; i++) {
  //     request.files.add(await http.MultipartFile.fromPath('face_images', _capturedImages[i].path));
  //   }
  //
  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     print("Upload success!");
  //   } else {
  //     print("Upload failed: ${response.statusCode}");
  //   }
  // }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capture Face: ${_steps[_step]}')),
      body: _cameraController.value.isInitialized
          ? CameraPreview(_cameraController)
          : Center(child: CircularProgressIndicator()),
    );
  }
}
