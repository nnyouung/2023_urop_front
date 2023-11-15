import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP 패키지 import
import 'dart:convert'; // JSON 인코딩/디코딩을 위한 패키지 import
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> ranking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');

    try {
      final response = await http.post(
        Uri.parse('http://ec2-54-172-150-42.compute-1.amazonaws.com:8080/users/ranking'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $email', // 아이디를 포함하여 요청
        },
        body: jsonEncode({
          'ranking': ranking,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        // 데이터 받아오기 성공 시의 동작 (여기서는 간단히 출력만)
        print('데이터 받아오기 성공');
      } else {
        // 데이터 받아오기 실패 시의 동작 (여기서는 간단히 출력만)
        print('데이터 받아오기 실패, statusCode: ${response.statusCode}');
      }
    } catch (error) {
      // 예외 처리 (네트워크 에러 등)
      print('에러 발생: $error');
    }
  }

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
