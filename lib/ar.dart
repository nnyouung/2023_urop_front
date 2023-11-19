import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class ArPage extends StatefulWidget {
  const ArPage({Key? key}) : super(key: key);

  @override
  ArPageState createState() => ArPageState();
}

class ArPageState extends State<ArPage> {
  WebSocketChannel channel;
  Uint8List? imageBytes;

  ArPageState() : channel = IOWebSocketChannel.connect('');  // 웹소켓 서버 주소로 변경하기

  @override
  void initState() {
    super.initState();

    imageBytes = Uint8List(0);  // imageBytes를 초기화

    // 웹 소켓에서 이미지 데이터 수신 시 처리
    channel.stream.listen((dynamic data) {
      Map<String, dynamic> decodedData = json.decode(data);  // 데이터가 문자열로 전송된 경우 디코딩

      List<int> decodedBytes = base64.decode(decodedData['image']);  // 이미지 데이터를 base64 디코딩

      // Uint8List로 변환하여 이미지 업데이트
      setState(() {
        imageBytes = Uint8List.fromList(decodedBytes);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: imageBytes != null
              ? Image.memory(imageBytes!)  // imageBytes가 있으면 이미지 표시
              : const Text('Waiting for image...'),  // imageBytes가 없으면 텍스트 표시
        ),
      ),
    );
  }

  @override
  // 페이지가 dispose될 때 웹소켓 연결 닫기
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
