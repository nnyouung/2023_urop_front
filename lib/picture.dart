import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

class PicturePage extends StatefulWidget {
  const PicturePage({Key? key}) : super(key: key);

  @override
  PicturePageState createState() => PicturePageState();
}

class PicturePageState extends State<PicturePage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  File? _image;
  bool _imageSelected = false;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.isNotEmpty) {
        _controller = CameraController(
          cameras[0],
          ResolutionPreset.medium,
        );
        _initializeControllerFuture = _controller!.initialize();
      }
    });
  }

  Widget _cameraPreviewWidget() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Text(
        '카메라를 불러올 수 없습니다.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }
    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: CameraPreview(_controller!),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      await _initializeControllerFuture;
      final XFile image = await _controller!.takePicture();
      setState(() {
        _image = File(image.path);
        _imageSelected = true;
      });
    } else {
      final pickedFile = await ImagePicker().pickImage(source: source);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          _imageSelected = true;
        }
      });
    }
  }

  void _onCompleteButtonPressed() {
    if (_imageSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이미지 선택 완료!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Picture Page'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _cameraPreviewWidget(),
            const Padding(
              padding: EdgeInsets.all(16.0),
            ),
            Container(
              width: 500,
              height: 500,
              decoration: const BoxDecoration(
                border: null,
                color: Colors.grey,
              ),
              child: _image != null
                  ? Image.file(_image!)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera),
                          onPressed: () {
                            _getImage(ImageSource.camera);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.photo),
                          onPressed: () {
                            _getImage(ImageSource.gallery);
                          },
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _imageSelected ? _onCompleteButtonPressed : null,
              child: const Text('선택 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
