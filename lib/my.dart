import 'package:flutter/material.dart';

class My {
  final String score;
  final int rank;
  final String date;

  My({
    required this.score,
    required this.rank,
    required this.date,
  });
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Ranking Page',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyRankingPage(),
    );
  }
}

class MyRankingPage extends StatelessWidget {
  MyRankingPage({super.key});

  // 가상의 유저 랭킹 데이터
  final List<My> userRankingList = [
    My(score: '2000', rank: 1, date: '2023.09.27 20:45'),
    My(score: '1892', rank: 2, date: '2023.09.20 01:15'),
    My(score: '1800', rank: 3, date: '2023.08.06 16:30'),
    My(score: '800', rank: 4, date: '2022.11.13 01:12'),
    My(score: '353', rank: 5, date: '2023.09.26 02:30'),
  ];

  // 화면을 렌더링하는 메서드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Ranking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              // 프로필 이미지 -> 일단 임의로 채워놓음
              radius: 60,
              backgroundImage: AssetImage(
                '/Users/eun/urop_sudoku/sudoku_front/lib/img/profile-user.png', // 경로 바꿔주기 (pubspec.yaml의 경로도 바꿔줘야 함)
              ),
            ),
            const SizedBox(height: 20), // 간격 조정
            const Text(
              // 유저 닉네임 -> 일단 임의로 채워놓음
              'UserNickname',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 70),
            const Text(
              // 표 제목
              'My ranking',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DataTable(
              // 표
              columns: const [
                DataColumn(label: Text('Rank')),
                DataColumn(label: Text('Score')),
                DataColumn(label: Text('Date')),
              ],
              rows: userRankingList.map((user) {
                return DataRow(
                  cells: [
                    DataCell(Text(user.rank.toString())),
                    DataCell(Text(user.score.toString())),
                    DataCell(Text(user.date.toString())),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
