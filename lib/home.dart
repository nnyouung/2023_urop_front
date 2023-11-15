import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart'; // 다른 페이지로 이동하기 위함
import 'ranking.dart';
import 'picture.dart';
import 'my.dart';
import 'sudokugame.dart';

void main() {
  runApp(const MyApp());
}

// 앱의 기본 구성을 정의하는 클래스
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Sudoku'),
      routes: {
        // map 형식으로 라우트하게끔
        '/automatic': (context) => const SudokuGame(),
        '/picture': (context) => const PicturePage(),
        // '/ar': (context) => ARPage(),
        '/ranking': (context) => RankingPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// 다른 페이지로 넘어가기 위한 함수: 주어진 url을 열 수 있으면 해당 url로 이동
// 취소선: 해당 코드 줄이 "비동기 함수"를 호출하기 때문으로, 해당 함수가 비동기적으로 실행되고 완료될 때까지 기다리라는 의미 -> 비동기 함수 호출 시 앞에 await 키워드를 사용
_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'URL을 열 수 없습니다: $url';
  }
}

// 앱의 홈페이지(앱을 실행했을 때 처음 보이는 페이지) 정의: StatefulWidget 상속
class _MyHomePageState extends State<MyHomePage> {
  // File? _image;

  // 화면을 렌더링하는 메서드: Scaffold 위젯을 이용하여 앱의 레이아웃 정의
  // Scaffold 위젯: 앱의 기본 레이아웃 구조 정의 (속성: appbar, body, drawer 등)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상단바 정의
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 50), // 간격 조정
            const Text(
              // 타이틀 글씨 설정
              "Make Sudoku",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 500),
            _buildAppBarItem(context, 'Automatic', const SudokuGame()),
            const SizedBox(width: 70),
            _buildAppBarItem(context, 'Picture', const PicturePage()),
            const SizedBox(width: 70),
            _buildAppBarItem(context, 'AR', RankingPage()),
            const SizedBox(width: 70),
            _buildAppBarItem(context, 'Ranking', RankingPage()),
            const SizedBox(width: 150),
          ],
        ),
        actions: [
          IconButton(
            // 사용자 계정
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyPage()),
              );
            },
          ),
          IconButton(
            // 설정
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 설정 페이지로 이동하는 코드 나중에 추가하기
            },
          ),
          const SizedBox(width: 50),
        ],
      ),
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
            ),
          ],
        ),
      ),
    );
  }

  // 상단바의 항목을 만들기 위한 함수
  // Widget _buildAppBarItem(BuildContext context, String text, String route) {
  //   // InkWell: 시각적으로 터치 피드백 제공 (일반적으로 잉크 효과)
  //   return InkWell(
  //     onTap: () {
  //       Navigator.pushNamed(context, route);
  //     },
  //     child: Text(
  //       text,
  //       style: const TextStyle(
  //         fontSize: 16.0,
  //       ),
  //     ),
  //   );
  // }
  Widget _buildAppBarItem(BuildContext context, String text, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }
}
