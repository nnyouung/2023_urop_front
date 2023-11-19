import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP 패키지 import
import 'dart:convert'; // JSON 인코딩/디코딩을 위한 패키지 import
import 'package:shared_preferences/shared_preferences.dart';

class UserRanking {
  final int rank;
  final String email;
  final String playtime;

  UserRanking({
    required this.rank,
    required this.email,
    required this.playtime,
  });
}

class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<UserRanking> userRankingList = [];

  @override
  void initState() {
    super.initState();
    // 위젯이 초기화될 때 서버에서 랭킹 데이터를 받아오는 함수 호출
    userRanking();
  }

  // 서버에서 랭킹 데이터를 받아오는 함수
  Future<void> userRanking() async {
    try {
      final response = await http.post(
        Uri.parse('http://ec2-54-172-150-42.compute-1.amazonaws.com:8080/users/ranking_all'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('서버 응답: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> topUsers = responseData['top_users'];
        final List<UserRanking> rankingData = parseRankingData(topUsers);
        updateRankingList(rankingData);
        print('데이터 받아오기 성공');
      } else {
        print('데이터 받아오기 실패, statusCode: ${response.statusCode}');
      }
    } catch (error) {
      print('에러 발생: $error');
    }
  }

  // 받아온 데이터로 userRankingList 업데이트
  void updateRankingList(List<UserRanking> rankingData) {
    setState(() {
      userRankingList = rankingData;
    });
  }

  List<UserRanking> parseRankingData(List<dynamic> data) {
    int rank = 1;
    return data.map((user) {
      final UserRanking my = UserRanking(
        rank: rank,
        email: user['email'],
        playtime: user['duration'],
      );
      rank++;
      return my;
    }).toList();
  }

  // // 가상의 유저 랭킹 데이터
  // final List<UserRanking> userRankingList = [
  //   UserRanking(email: 'User1', rank: 1, time: '00:45'),
  //   UserRanking(email: 'User2', rank: 2, time: '01:15'),
  //   UserRanking(email: 'User3', rank: 3, time: '01:30'),
  //   UserRanking(email: 'User4', rank: 4, time: '02:05'),
  //   UserRanking(email: 'User5', rank: 5, time: '02:30'),
  // ];

  // 화면을 렌더링하는 메서드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('User Ranking'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '유저 순위',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 0),
            DataTable(
              // 랭킹 (표 형태)
              columns: const [
                DataColumn(label: Text('순위')),
                DataColumn(label: Text('이메일')),
                DataColumn(label: Text('걸린 시간')),
              ],
              rows: userRankingList.map((user) {
                return DataRow(
                  cells: [
                    DataCell(Center(child: Text(user.rank.toString()))),
                    DataCell((Center(child: Text(user.email)))),
                    DataCell((Center(child: Text(user.playtime)))),
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