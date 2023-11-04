// 랭킹 시스템에 이용할 users 정보를 가져와야 함

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> fetchUserInfo(String id) async {
  var url = Uri.parse('API_URL'); // 사용자 정보를 가져올 API의 URL

  var response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $id', // 아이디를 포함하여 요청하기 (사용자 식별용)
    },
  );

  if (response.statusCode == 200) {
    var userData = jsonDecode(response.body);
    print('$userData');
  } else {
    print('Failed');
  }
}
