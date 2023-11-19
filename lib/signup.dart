import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP 패키지 import
import 'dart:convert'; // JSON 인코딩/디코딩을 위한 패키지 import

class SignupPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();

  SignupPage({super.key});

  // 회원가입 함수
  Future<void> signup() async {
    String email = emailController.text;
    String password = passwordController.text;
    String passwordCheck = passwordCheckController.text;

    try {
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        // 회원가입 성공 시의 동작 (여기서는 간단히 출력만)
        print('회원가입 성공');
      } else {
        // 회원가입 실패 시의 동작 (여기서는 간단히 출력만)
        print('회원가입 실패, statusCode: ${response.statusCode}');
      }
    } catch (error) {
      // 예외 처리 (네트워크 에러 등)
      print('에러 발생: $error');
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
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'PASSWORD (8자 이상 입력하시오.)',
              ),
            ),
            TextField(
              controller: passwordCheckController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'CHECK PASSWORD',
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => signup(), // 버튼 텍스트 스타일 설정
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // 버튼 색상 설정
                ), // 버튼 클릭 시 check 함수 호출
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
