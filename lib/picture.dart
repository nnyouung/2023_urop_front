import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PicturePage extends StatefulWidget {
  const PicturePage({Key? key}) : super(key: key);

  @override
  PicturePageState createState() => PicturePageState();
}

class PicturePageState extends State<PicturePage> {
  XFile? _image;  //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker();  //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담김
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);  //가져온 이미지를 _image에 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            _buildPhotoArea(),
            const SizedBox(height: 20),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? SizedBox(
            width: 300,
            height: 300,
            child: Image.file(File(_image!.path)),  // 가져온 이미지를 화면에 띄워줌
          )
        : Container(
            width: 300,
            height: 300,
            color: Colors.grey,
          );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
        ),
          onPressed: () {
            getImage(ImageSource.camera);  // 카메라로 찍은 사진 가져오기
          },
          child: const Text("카메라"),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
        ),
          onPressed: () {
            getImage(ImageSource.gallery); // 갤러리에서 사진 가져오기
          },
          child: const Text("갤러리"),
        ),
      ],
    );
  }
}