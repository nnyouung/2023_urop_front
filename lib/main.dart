import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Make Sudoku',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/', // 웹이 시작될 때 초기 화면 설정
      routes: {
        '/': (context) => MyHomePage(), // 루트 경로로 메인(홈) 화면 설정
        '/login': (context) => LoginPage(), // 로그인 화면 설정
        '/signup': (context) => SignupPage(), // 회원가입 화면 설정
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Make Sudoku', // 웹사이트 이름
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white), // 굵은 글씨체, 폰트 크기, 글자 색상 흰색
        ),
        backgroundColor: Colors.grey[900], // 상단 내비게이션바 색상 설정
        actions: [
          SizedBox(width: 8), // 오른쪽 여백 추가
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
                },
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup'); // 회원가입 페이지로 이동
                },
                child: Text(
                  'SIGNUP',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.text_fields), // Text 탭
            onPressed: () {
              // 'Text' 버튼을 눌렀을 때의 동작 추가
            },
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.autorenew), // Automatic 탭
            onPressed: () {
              // 'Automatic' 버튼을 눌렀을 때의 동작 추가
            },
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.image), // Picture 탭
            onPressed: () {
              // 'Picture' 버튼을 눌렀을 때의 동작 추가
            },
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.search), // AR 탭
            onPressed: () {
              // 'AR' 버튼을 눌렀을 때의 동작 추가
            },
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.leaderboard), // Ranking 탭
            onPressed: () {
              // 'Ranking' 버튼을 눌렀을 때의 동작 추가
            },
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.person), // 유저페이지 탭
            onPressed: () {
              // 'userpage' 버튼을 눌렀을 때의 동작 추가
            },
          ),
          SizedBox(width: 8), // 오른쪽 여백 추가
        ],
      ),
      body: Center(
        child: const Text('메인 화면'),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) {
    // 로그인 로직 구현

    // 사용자가 입력한 아이디와 비밀번호를 가져옴
    String username = usernameController.text;
    String password = passwordController.text;

    if (username == "admin" && password == "password") {
      // 아이디와 비밀번호가 올바를 경우, 로그인 성공
      Navigator.pop(context); // 로그인 성공 시 메인 화면으로 이동
    } else {
      // 아이디나 비밀번호가 올바르지 않을 경우, 오류 다이얼로그 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("로그인 실패"),
            content: Text("아이디나 비밀번호가 올바르지 않습니다."),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LOGIN PAGE',
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
              controller: usernameController, // 컨트롤러 설정
              decoration: InputDecoration(
                labelText: 'INPUT ID', // 레이블 텍스트 설정
              ),
            ),

            // 비밀번호 입력 필드
            TextField(
              controller: passwordController, // 컨드롤러 설정
              obscureText: true, // 비밀번호 입력 시 입력 내용을 가려서 보이지 않게 함
              decoration: InputDecoration(
                labelText: 'INPUT PASSWORD', // 레이블 텍스트 설정
              ),
            ),
            SizedBox(height: 20), // 공간 여백 추가
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => login(context), // 로그인 버튼 클릭시 로그인 함수 호출
                child: Text('LOGIN'), // 버튼 텍스트 설정
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
