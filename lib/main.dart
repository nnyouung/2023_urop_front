import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'signup.dart';

void main() {
  runApp(const MyApp());
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

class MyLogin extends StatelessWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const LoginPage(title: 'LOGIN PAGE'),
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 로그인 함수
  Future<void> login() async {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      // 서버로 로그인 요청
      final response = await http.post(
        Uri.parse('http://ec2-54-172-150-42.compute-1.amazonaws.com:8080/users/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // 서버 응답이 성공(상태코드 200)이면
      if (response.statusCode == 200) {
        // 서버 응답 데이터에서 사용자 ID 추출
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String email = responseData['email'].toString();

        // 사용자 ID를 SharedPreferences를 사용해 저장
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);

        // 홈 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'Home'),
          ),
        );
      } else {
        // 로그인 실패 시 에러 메시지 출력
        print('로그인 실패, statusCode: ${response.statusCode}');
      }
    } catch (error) {
      // 예외 발생 시 에러 메시지 출력
      print('에러 발생: $error');
    }
  }

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 이메일 입력 필드
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: '이메일 입력',
              ),
            ),
            // 비밀번호 입력 필드
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호 입력',
              ),
            ),
            const SizedBox(height: 20),
            // 회원가입 및 로그인 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 회원가입 페이지로 이동
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
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => login(),
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
}
