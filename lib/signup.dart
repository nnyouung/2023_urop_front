import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  SignupPage({super.key});

  Future<void> check(BuildContext context) async {
    // 각각의 입력 필드에서 사용자가 입력한 값을 가져옴
    String id = idController.text;
    String username = usernameController.text;
    String password = passwordController.text;
    String passwordCheck = passwordCheckController.text;
    String email = emailController.text;

    // 필수 필드가 모두 채워져 있는지 확인
    if (id.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        passwordCheck.isEmpty ||
        email.isEmpty) {
      // 필수 필드 중 하나라도 비어 있으면 경고 다이얼로그 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("경고"),
            content: const Text("모든 필드를 입력해주세요."),
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
      return;
    }

    // 서버로 회원가입 요청을 보낼 URL 설정 (Django 서버의 URL에 맞게 변경해야 함)
    String signupUrl = 'http://localhost:';

    // POST 요청 데이터 생성
    Map<String, String> requestData = {
      'id': id,
      'username': username,
      'password': password,
      'passwordCheck': passwordCheck,
      'email': email,
    };

    // POST 요청 보내기
    final response = await http.post(
      Uri.parse(signupUrl),
      body: requestData,
    );

    if (response.statusCode == 200) {
      // 회원가입 성공 시의 동작
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("회원가입 성공"),
            content: const Text("회원가입이 완료되었습니다."),
            actions: [
              TextButton(
                child: const Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  Navigator.pop(context); // 회원가입 성공 시 메인 화면으로 이동
                },
              ),
            ],
          );
        },
      );
    } else {
      // 회원가입 실패 시의 동작
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("회원가입 실패"),
            content: const Text("회원가입에 실패하였습니다."),
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
          'SIGNUP PAGE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 여백 설정
        child: Column(
          children: [
            // 아이디 입력 필드
            TextField(
              controller: idController, // 컨트롤러 설정
              decoration: const InputDecoration(
                labelText: 'ID', // 레이블 텍스트 설정
              ),
            ),
            // 유저네임 입력 필드
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'USERNAME',
              ),
            ),
            // 비밀번호 입력 필드
            TextField(
              controller: passwordController,
              obscureText: true, // 비밀번호 입력 시 입력 내용을 가려서 보이지 않게 함
              decoration: const InputDecoration(
                labelText: 'PASSWORD',
              ),
            ),
            // 비밀번호 확인 필드
            TextField(
              controller: passwordCheckController,
              obscureText: true, // 비밀번호 확인 시 입력 내용을 가려서 보이지 않게 함
              decoration: const InputDecoration(
                labelText: 'CHECK PASSWORD',
              ),
            ),
            // 이메일 입력 필드
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'EMAIL',
              ),
            ),
            const SizedBox(height: 20), // 위젯간의 간격 조정
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => check(context), // 버튼 텍스트 스타일 설정
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // 버튼 색상 설정
                ), // 버튼 클릭 시 check 함수 호출
                child: const Text(
                  'SIGNUP',
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
