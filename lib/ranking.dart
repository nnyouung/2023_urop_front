import 'package:flutter/material.dart';

class UserRanking {
  final String nickname;
  final int rank;
  final String time;

  UserRanking({
    required this.nickname,
    required this.rank,
    required this.time,
  });
}

class RankingPage extends StatelessWidget {
  RankingPage({super.key});

  // 가상의 유저 랭킹 데이터
  final List<UserRanking> userRankingList = [
    UserRanking(nickname: 'User1', rank: 1, time: '00:45'),
    UserRanking(nickname: 'User2', rank: 2, time: '01:15'),
    UserRanking(nickname: 'User3', rank: 3, time: '01:30'),
    UserRanking(nickname: 'User4', rank: 4, time: '02:05'),
    UserRanking(nickname: 'User5', rank: 5, time: '02:30'),
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
            const Text(
              'User ranking',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 0),
            DataTable(
              // 랭킹 (표 형태)
              columns: const [
                DataColumn(label: Text('Rank')),
                DataColumn(label: Text('Nickname')),
                DataColumn(label: Text('Time')),
              ],
              rows: userRankingList.map((user) {
                return DataRow(
                  cells: [
                    DataCell(Text(user.rank.toString())),
                    DataCell(Text(user.nickname)),
                    DataCell(Text(user.time)),
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
