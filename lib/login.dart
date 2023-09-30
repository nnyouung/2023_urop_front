import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // 토큰 저장을 위한 패키지

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 서버 주소
  final String serverUrl = 'http://localhost:'; // Django 서버 주소로 변경해야 함

  Future<void> login(BuildContext context) async {
    // 사용자가 입력한 아이디와 비밀번호를 가져옴
    String username = usernameController.text;
    String password = passwordController.text;

    // 로그인 요청 데이터 생성
    final Map<String, dynamic> data = {
      'email': username,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('$serverUrl/api/login/'), // 로그인 API 엔드포인트 URL로 변경
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final token = jsonData['token'];

      // 토큰 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);

      // 로그인 성공 시 메인 화면으로 이동
      Navigator.pop(context);
    } else if (response.statusCode == 401) {
      // 아이디나 비밀번호가 올바르지 않을 경우, 오류 다이얼로그 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("로그인 실패"),
            content: const Text("아이디나 비밀번호가 올바르지 않습니다."),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '로그인 페이지',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 여백 설정
        child: Column(
          children: [
            // 아이디 입력 필드
            TextField(
              controller: usernameController, // 컨트롤러 설정
              decoration: const InputDecoration(
                labelText: '아이디 입력', // 레이블 텍스트 설정
              ),
            ),

            // 비밀번호 입력 필드
            TextField(
              controller: passwordController, // 컨트롤러 설정
              obscureText: true, // 비밀번호 입력 시 입력 내용을 가려서 보이지 않게 함
              decoration: const InputDecoration(
                labelText: '비밀번호 입력', // 레이블 텍스트 설정
              ),
            ),
            const SizedBox(height: 20), // 공간 여백 추가
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => login(context), // 버튼 텍스트 스타일 설정
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // 버튼 색상 설정
                ), // 로그인 버튼 클릭 시 로그인 함수 호출
                child: const Text(
                  '로그인',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: LoginPage()));
