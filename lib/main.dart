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

  // 로그인 결과를 팝업으로 표시하는 함수
  Future<void> showResultDialog(BuildContext context, String message, bool success) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그인 결과'),
          content: Text(message), // 로그인 결과 메시지 표시
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 창 닫기

                if (success) {
                  // 로그인이 성공하면 홈 화면으로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Home'),
                    ),
                  );
                } else {
                  // 로그인 실패 또는 오류가 있으면 로그인 화면에 남아 있도록 함
                }
              },
              child: Text('확인'), // 확인 버튼 텍스트
            ),
          ],
        );
      },
    );
  }

  // 로그인을 시도하는 함수
  Future<void> login(BuildContext context) async {
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

      // 서버 응답 확인
      if (response.statusCode == 200) {
        // 서버 응답 데이터에서 사용자 이메일 추출
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String email = responseData['email'].toString();

        // 사용자 이메일을 SharedPreferences를 사용해 저장
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);

        // 로그인 성공 시 성공 메시지 출력
        print('로그인 성공');
        // 로그인 성공 시 팝업창 표시
        showResultDialog(context, '로그인 성공', true);
      } else {
        // 로그인 실패 시 에러 메시지 출력
        print('로그인 실패, statusCode: ${response.statusCode}');
        // 로그인 실패 시 팝업창 표시
        showResultDialog(context, '로그인 실패', false);
      }
    } catch (error) { // 예외 처리 (네트워크 에러 등)
      // 예외 발생 시 에러 메시지 출력
      print('에러 발생: $error');
      // 예외 발생 시 팝업창 표시
      showResultDialog(context, '에러 발생: $error', false);
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
                // 로그인 버튼
                ElevatedButton(
                  onPressed: () => login(context), // context를 전달하여 팝업창이 표시될 수 있도록 함
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ), // 버트 클릭 시 login 함수 호출
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
