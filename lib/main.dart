import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart'; // 다른 페이지로 이동하기 위함
import 'ranking.dart';
import 'picture.dart';
import 'my.dart';

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
      home: const MyHomePage(title: 'Make sudoku'),
      routes: {
        // map 형식으로 라우트하게끔
        // '/text': (context) => TextPage(),
        // '/automatic': (context) => AutomaticPage(),
        '/picture': (context) => PicturePage(),
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

class _MyHomePageState extends State<MyHomePage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 50), // 간격 조정
            Text(
              // 타이틀 글씨 설정
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 350),
            _buildAppBarItem(context, 'Text', '/text'),
            SizedBox(width: 100),
            _buildAppBarItem(context, 'Automatic', '/automatic'),
            SizedBox(width: 100),
            _buildAppBarItem(context, 'Picture', '/picture'),
            SizedBox(width: 100),
            _buildAppBarItem(context, 'AR', '/ar'),
            SizedBox(width: 100),
            _buildAppBarItem(context, 'Ranking', '/ranking'),
          ],
        ),
        actions: [
          IconButton(
            // 사용자 계정
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              );
            },
          ),
          IconButton(
            // 설정
            icon: Icon(Icons.settings),
            onPressed: () {
              // 설정 페이지로 이동하는 코드 나중에 추가하기
            },
          ),
          SizedBox(width: 50),
        ],
      ),
      body: Center(
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

  Widget _buildAppBarItem(BuildContext context, String text, String route) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }
}
