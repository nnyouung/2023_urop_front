import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP 패키지 import
import 'dart:convert'; // JSON 인코딩/디코딩을 위한 패키지 import

class SignupPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();

  SignupPage({super.key});

  // 회원가입 결과를 팝업으로 표시하는 함수
  Future<void> showResultDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원가입 결과'),
          content: Text(message), // 회원가입 결과 메시지 표시
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 창 닫기
              },
              child: Text('확인'), // 확인 버튼 텍스트
            ),
          ],
        );
      },
    );
  }

  // 회원가입을 시도하는 함수
  Future<void> signup(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    String passwordCheck = passwordCheckController.text;

    try {
      // 서버에 회원가입 요청
      final response = await http.post(
        Uri.parse('http://ec2-54-172-150-42.compute-1.amazonaws.com:8080/users/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'passwordCheck': passwordCheck,
        }),
      );

      // 서버 응답 확인
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        // 회원가입 성공 시 성공 메시지 출력
        print('회원가입 성공');
        // 회원가입 성공 시 팝업창 표시
        showResultDialog(context, '회원가입 성공');
      } else {
        // 회원가입 실패 시 에러 메시지 출력
        print('회원가입 실패, statusCode: ${response.statusCode}');
        // 회원가입 실패 시 팝업창 표시
        showResultDialog(context, '회원가입 실패');
      }
    } catch (error) { // 예외 처리 (네트워크 에러 등)
      // 예외 발생 시 에러 메시지 출력
      print('에러 발생: $error');
      // 예외 발생 시 팝업창 표시
      showResultDialog(context, '에러 발생: $error');
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 이메일 입력 필드
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'EMAIL',
              ),
            ),
            // 비밀번호 입력 필드
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'PASSWORD (8자 이상 입력하시오.)',
              ),
            ),
            // 비밀번호 확인 입력 필드
            TextField(
              controller: passwordCheckController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'CHECK PASSWORD',
              ),
            ),
            const SizedBox(height: 20),
            // 회원가입 버튼
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => signup(context), // context를 전달하여 팝업창이 표시될 수 있도록 함
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // 버튼 색상 설정
                ), // 버튼 클릭 시 signup 함수 호출
                child: const Text(
                  '회원가입',
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
