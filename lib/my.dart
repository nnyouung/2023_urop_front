import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class My {
  final int rank;
  final String playtime;

  My({
    required this.rank,
    required this.playtime,
  });
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<My> myRankingList = [];

  @override
  void initState() {
    super.initState();
    // 위젯이 초기화될 때 ranking 함수 호출
    ranking();
  }

  // 랭킹 부분 데이터를 받아오기 위한 통신 코드
  Future<void> ranking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');

    try {
      final response = await http.post(
        Uri.parse('http://ec2-54-172-150-42.compute-1.amazonaws.com:8080/users/ranking'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": email,  // 이메일에 맞는 정보를 받기 위해 이메일을 포함하여 요청
        }),
      );

      if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<My> rankingData = parseRankingData(data);
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
  void updateRankingList(List<My> rankingData) {
    setState(() {
      myRankingList = rankingData;
    });
  }

  List<My> parseRankingData(Map<String, dynamic> data) {
  List<String> durations = (data['durations'] as List<dynamic>).cast<String>();
  int rank = 1;
  return durations.map((duration) {
    final My my = My(
      rank: rank,
      playtime: duration,
    );
    rank++;
    return my;
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              // 표 제목
              '내 랭킹',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DataTable(
              // 표
              columns: const [
                DataColumn(label: Text('순위')),
                DataColumn(label: Text('걸린 시간')),
              ],
              rows: myRankingList.map((user) {
                return DataRow(
                  cells: [
                    DataCell(Text(user.rank.toString())),
                    DataCell(Text(user.playtime)),
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
