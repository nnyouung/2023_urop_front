import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'picture_sudokugame.dart';
import 'dart:convert';

class PicturePage extends StatefulWidget {
  const PicturePage({Key? key}) : super(key: key);

  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  String? result;
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    result = null;
  }

  // 이미지 업로드를 처리하는 함수
  Future<void> uploadImage(BuildContext context, File file) async {
    var uri = Uri.parse('http://ec2-54-172-150-42.compute-1.amazonaws.com:8080/img/');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes('image', await file.readAsBytes(), filename: 'test.png'));

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print('서버 응답: $responseData');

      // 서버 응답을 JSON으로 파싱
      Map<String, dynamic> data = json.decode(responseData);

      // 서버 응답을 확인하고 적절한 조건에 따라 페이지를 이동
      if (!mounted) return;
      if (data['status'] == 'success') {
        result = data['result'];
        print("디버깅용 PicturePage result: $result");
      }
    } catch (error) {
      print('에러: $error');
    }
  }

  // 카메라 또는 갤러리에서 이미지를 가져오는 함수
  Future<void> getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });

      // 이미지 선택 후 이미지 업로드 함수 호출
      if (!mounted) return;
      await uploadImage(context, File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          _buildPhotoArea(),
          const SizedBox(height: 20),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? SizedBox(
            width: 300,
            height: 300,
            child: Image.file(File(_image!.path)),
          )
        : Container(
            width: 300,
            height: 300,
            color: Colors.grey,
          );
  }

  Widget _buildButton() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
            onPressed: () {
              getImage(ImageSource.camera);
            },
            child: const Text("카메라"),
          ),
          const SizedBox(width: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
            onPressed: () {
              getImage(ImageSource.gallery);
            },
            child: const Text("갤러리"),
          ),
        ],
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PictureSudokuGame(result: result)),
            );
          // if (result != null) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => PictureSudokuGame(result: result)),
          //   );
          // } else if (_image == null) {
          //   showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return AlertDialog(
          //         title: const Text('알림'),
          //         content: const Text('스도쿠 문제 사진을 올려야 게임 생성이 가능합니다.'),
          //         actions: [
          //           TextButton(
          //             onPressed: () {
          //               Navigator.of(context).pop();
          //             },
          //             child: const Text('확인'),
          //           ),
          //         ],
          //       );
          //     },
          //   );
          // } else {
          //   showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return AlertDialog(
          //         title: const Text('알림'),
          //         content: const Text('조금만 기다려주세요.'),
          //         actions: [
          //           TextButton(
          //             onPressed: () {
          //               Navigator.of(context).pop();
          //             },
          //             child: const Text('확인'),
          //           ),
          //         ],
          //       );
          //     },
          //   );
          // }
        },
        child: const Text("게임 만들기"),
      ),
    ],
  );
}
}
