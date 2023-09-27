import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void check(BuildContext context) {
    // 회원가입 로직

    // 1. 각각의 입력 필드에서 사용자가 입력한 값을 가져옴
    String id = idController.text;
    String username = usernameController.text;
    String password = passwordController.text;
    String passwordCheck = passwordCheckController.text;
    String email = emailController.text;

    // 2. 모든 필드가 채워져 있는지 확인
    if (id.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        passwordCheck.isEmpty ||
        email.isEmpty) {
      // 3. 만약 하나라도 비어있으면 경고 다이얼로그 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("경고"),
            content: Text("모든 필드를 입력해주세요."),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );
    } else if (password != passwordCheck) {
      // 4. 비밀번호와 비밀번호 확인이 일치하지 않을 경우 경고 다이얼로그 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("경고"),
            content: Text("비밀번호가 일치하지 않습니다."),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );
    } else {
      // 5. 모든 필드가 올바르게 입력되었을 경우 회원가입 성공 다이얼로그 표시 후 메인 화면으로 이동
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("회원가입 성공"),
            content: Text("회원가입이 완료되었습니다."),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  Navigator.pop(context); // 회원가입 성공 시 메인 화면으로 이동
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
        title: Text(
          'SIGNUP PAGE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[900], // 상단 내비게이션바 색상 설정
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // 여백 설정
        child: Column(
          children: [
            // 아이디 입력 필드
            TextField(
              controller: idController, // 컨트롤러 설정
              decoration: InputDecoration(
                labelText: 'ID', // 레이블 텍스트 설정
              ),
            ),
            // 유저네임 입력 필드
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'USERNAME',
              ),
            ),
            // 비밀번호 입력 필드
            TextField(
              controller: passwordController,
              obscureText: true, // 비밀번호 입력 시 입력 내용을 가려서 보이지 않게 함
              decoration: InputDecoration(
                labelText: 'PASSWORD',
              ),
            ),
            // 비밀번호 확인 필드
            TextField(
              controller: passwordCheckController,
              obscureText: true, // 비밀번호 확인 시 입력 내용을 가려서 보이지 않게 함
              decoration: InputDecoration(
                labelText: 'CHECK PASSWORD',
              ),
            ),
            // 이메일 입력 필드
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'EMAIL',
              ),
            ),
            SizedBox(height: 20), // 위젯간의 간격 조정
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => check(context), // 버튼 클릭 시 check 함수 호출
                child: Text('SIGNUP'), // 버튼 텍스트 설정
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // 버튼 색상 설정
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
