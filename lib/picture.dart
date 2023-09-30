import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // 사진 올리기 위함

class PicturePage extends StatefulWidget {
  const PicturePage({super.key});

  @override
  PicturePageState createState() => PicturePageState();
}

class PicturePageState extends State<PicturePage> {
  File? _image;
  bool _imageSelected = false;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageSelected = true;
      }
    });
  }

  // 이미지 선택 완료 시 동작하는 함수
  void _onCompleteButtonPressed() {
    if (_imageSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이미지 선택 완료!'),
        ),
      );

      // 이미지 선택이 완료된 후, 어떻게 할지 나중에 동작 추가해야 함.
    }
  }

  // 화면을 렌더링하는 메서드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
            ),
            Container(
              // 사진이 들어갈 사각형 설정
              width: 500,
              height: 500,
              decoration: const BoxDecoration(
                border: null,
                color: Colors.grey,
              ),
              // 이미지 선택과 관련된 UI 부분
              child: _image != null
                  ? Image.file(_image!)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          // 카메라 아이콘
                          icon: const Icon(Icons.camera),
                          onPressed: () {
                            _getImage(ImageSource.camera);
                          },
                        ),
                        IconButton(
                          // 사진 불러오기 아이콘
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
