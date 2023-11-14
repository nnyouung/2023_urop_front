import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP 패키지 import
import 'dart:convert'; // JSON 인코딩/디코딩을 위한 패키지 import

class LoginAPI {
  // HTTP POST 요청을 보내고 응답을 처리하는 함수
  static Future<void> postUserRequest(String id, String password) async {
    // 로그인 API 엔드포인트 URL 설정
    String loginUrl = 'http://ec2-54-172-150-42.compute-1.amazonaws.com/login'; // 이 부분을 실제 서버 URL로 변경해야 함

    Map<String, String> requestData = {
      'id': id,
      'password': password,
    };

    final response = await http.post(
      Uri.parse(loginUrl),
      body: requestData,
    );

    if (response.statusCode == 200) {
      // 로그인 성공 시 서버로부터 id 값을 받아옵니다.
      Map<String, dynamic> responseData = json.decode(response.body);
      String receivedId = responseData['id'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("로그인 성공"),
            content: Text("환영합니다, $receivedId님!"),
            actions: [
              TextButton(
                child: const Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("로그인 실패"),
            content: const Text("로그인에 실패하였습니다. 아이디와 비밀번호를 확인해주세요."),
            actions: [
              TextButton(
                child: const Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );
    }
  }
}