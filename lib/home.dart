import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart'; // 다른 페이지로 이동하기 위함
import 'ranking.dart';
import 'picture.dart';
import 'my.dart';
import 'sudokugame.dart';
import 'ar.dart';
import 'package:http/http.dart' as http; // HTTP 패키지 import
import 'dart:convert'; // JSON 인코딩/디코딩을 위한 패키지 import
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

void main() {
  runApp(const MyApp());
}

// 앱의 기본 구성을 정의하는 클래스
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // title: 'Sudoku',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Sudoku'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


// 앱의 홈페이지(앱을 실행했을 때 처음 보이는 페이지) 정의: StatefulWidget 상속
class _MyHomePageState extends State<MyHomePage> {
  // File? _image;
  int selectedPage = 0;

  // 호출할 페이지
  final _pageOptions = [const SudokuGame(), const PicturePage(), const ArPage(), RankingPage()];

  // 화면을 렌더링하는 메서드: Scaffold 위젯을 이용하여 앱의 레이아웃 정의
  // Scaffold 위젯: 앱의 기본 레이아웃 구조 정의 (속성: appbar, body, drawer 등)
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            SizedBox(width: 50), // 간격 조정
            Text(
              // 타이틀 글씨 설정
              "Make Sudoku",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
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
      body: _pageOptions[selectedPage],
      bottomNavigationBar: ConvexAppBar(
        initialActiveIndex: 0, //optional, default as 0
        backgroundColor: Colors.white, // 배경색
        color: Colors.grey[500],
        activeColor: Colors.grey[700],
        elevation: 1, // elevation 0으로 처리하면 그림자가 제거됨
        items: const [
          TabItem(
            icon: Icons.home,  // 메인에 뜨는 화면
          ),
          TabItem(icon: Icons.file_copy_rounded),
          TabItem(icon: Icons.remove_red_eye),
          TabItem(icon: Icons.people),
        ],

        // 어떤 탭 인덱스를 눌렀는지 트리거 처리하여 페이지를 변경함
        onTap: (int index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
    );
  }
}