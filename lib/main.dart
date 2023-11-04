import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // 토큰 저장을 위한 패키지
import 'home.dart';
import 'signup.dart';

void main() {
  runApp(const MyLogin());
}

class MyLogin extends StatelessWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const LoginPage(title: 'Login'),
      initialRoute: '/',
      routes: {
        '/home': (context) => const MyHomePage(title: 'Home'),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 서버 주소
  final String serverUrl = 'http://localhost:'; // Django 서버 주소로 변경해야 함

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20), // 간격 조정
                ElevatedButton(
                  onPressed: () => login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username == "admin" && password == "password") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const MyHomePage(title: 'Home'), // 로그인 성공 시 이동할 페이지
        ),
      );
    } else {
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
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyLogin(), // Home 또는 원하는 위젯으로 대체
      routes: const {
        // 여기에 라우트 추가
      },
    );
  }
}
