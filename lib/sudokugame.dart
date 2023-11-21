import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SudokuGame extends StatefulWidget {
  const SudokuGame({super.key});

  @override
  _SudokuGameState createState() => _SudokuGameState();
}

class _SudokuGameState extends State<SudokuGame> {
  late List<List<int>> sudokuBoard; // 스도쿠 게임 보드
  late List<List<int>> sudokuAnswerBoard; // 스도쿠 답
  int selectedNumber = -1; // 숫자패드에서 선택된 숫자
  bool eraseMode = false; // 지우기 모드
  List<HistoryItem> history = []; // 실행 취소를 위해 과거 입력들 저장하는 리스트
  var clearTime;
  var formattedTime;
  var startTime;
  var endTime;
  var email;

  @override
  void initState() {
    // 초기화
    super.initState();
    sudokuBoard = List.generate(9, (_) => List<int>.filled(9, 0));
    fetchSudokuData();
  }

  // List<List<int>>
  void fillSudokuBoard(List<List<int>> sudokuData) {
    // 스도쿠 보드에 숫자를 채우는 함수
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        sudokuBoard[row][col] = sudokuData[row][col];
      }
    }
  }

  Future<void> ranking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
  }

  Future<void> fetchSudokuData() async {
    // 스도쿠 게임(list) 불러오는 함수
    final response = await http.post(
      Uri.parse('http://ec2-54-172-150-42.compute-1.amazonaws.com:8080/new/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({}),
    );

    if (response.statusCode == 200) {
      setState(() {
        final data = json.decode(response.body);
        final rawData = data['arr'];
        var sudokuData = List.generate(9, (_) => List<int>.filled(9, 0));

        for (int row = 0; row < 9; row++) {
          for (int col = 0; col < 9; col++) {
            sudokuData[row][col] = rawData[row][col];
          }
        }
        fillSudokuBoard(sudokuData);
        history = [];
      });
    } else {
      throw Exception('Failed to fetch Sudoku data');
    }
    /////////
    final response2 = await http.post(
      Uri.parse('http://ec2-54-172-150-42.compute-1.amazonaws.com:8080/solve/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'arr': json.decode(response.body)['arr']}),
    );
    if (response2.statusCode == 200) {
      setState(() {
        final data = json.decode(response2.body);
        var rawData = data['result'];
        rawData = rawData.split(" ");

        print(rawData);

        var sudokuAnswerData = List.generate(9, (_) => List<int>.filled(9, 0));

        for (int row = 0; row < 9; row++) {
          for (int col = 0; col < 9; col++) {
            sudokuAnswerData[row][col] = int.parse(rawData[row * 9 + col]);
          }
        }
        sudokuAnswerBoard = sudokuAnswerData;
      });
    } else {
      throw Exception('Failed to fetch Sudoku data');
    }
    startTime = DateTime.now();
  }

  Future<void> sendClearTime() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? email = prefs.getString('email');
    const email = "kmu@kookmin.ac.kr";

    // print(clearTime);
    var dateCleartime = clearTime.toString();
    var splitData = dateCleartime.split(':');
    splitData[2] = splitData[2].substring(0, 2);

    List<String> parts = (splitData.join(':')).split(':');

    int hours = int.parse(parts[0]);
    String formattedTime =
        "2000-07-10 ${hours.toString().padLeft(2, '0')}:${parts[1]}:${parts[2]}";

    final response = await http.post(
      Uri.parse(
          'http://ec2-54-172-150-42.compute-1.amazonaws.com:8080/users/rankingDB'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'duration': formattedTime,
      }),
    );

    // 서버 응답이 성공(상태코드 200)이면
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      // 로그인 실패 시 에러 메시지 출력
      print('전송 실패, statusCode: ${response.statusCode}');
    }
  }

  Future<void> showSuccessDialog() async {
    clearTime = endTime.difference(startTime);
    formattedTime = clearTime.toString();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('맞았습니다!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('시간:'),
                Text(formattedTime),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showFailDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('틀렸습니다!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('아쉽네요...'),
                Text('다시 도전해보세요..'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildSudokuBoard() {
    // 스도쿠 게임 보드 만드는 함수
    return Column(
      children: List.generate(9, (row) {
        return Row(
          children: List.generate(9, (col) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (eraseMode) {
                    if (sudokuBoard[row][col] != 0) {
                      history.add(HistoryItem(row, col, sudokuBoard[row][col]));
                      sudokuBoard[row][col] = 0;
                    }
                  } else if (selectedNumber != -1) {
                    history.add(HistoryItem(row, col, sudokuBoard[row][col]));
                    sudokuBoard[row][col] = selectedNumber;
                  }
                });
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: (((0 <= row && row <= 2) && (0 <= col && col <= 2)) ||
                          ((3 <= row && row <= 5) && (3 <= col && col <= 5)) ||
                          ((6 <= row && row <= 8) && (6 <= col && col <= 8)) ||
                          ((0 <= row && row <= 2) && (6 <= col && col <= 8)) ||
                          ((6 <= row && row <= 8) && (0 <= col && col <= 2)))
                      ? const Color.fromARGB(255, 232, 232, 232)
                      : Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  sudokuBoard[row][col] != 0
                      ? sudokuBoard[row][col].toString()
                      : '',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget buildNumberPad() {
    // 숫자 패드 만드는 함수
    return Column(
      children: [
        buildButtonRow(
            [buildUndoButton(), buildClearButton(), buildNewGameButton()], 1.0),
        const SizedBox(height: 20),
        buildNumberGrid(),
        const SizedBox(height: 20),
        buildButtonRow([buildCheckButton(), buildcompleteButton()], 2.0),
      ],
    );
  }

  Widget buildNumberGrid() {
    // 숫자 패드의 배열 만드는 함수
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) {
        final number = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              if (eraseMode) {
                eraseMode = false;
                selectedNumber = number;
              } else {
                selectedNumber = number;
              }
            });
          },
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(),
              color: selectedNumber == number
                  ? const Color.fromARGB(255, 184, 184, 184)
                  : Colors.white,
              shape: BoxShape.rectangle,
            ),
            alignment: Alignment.center,
            child: Text(
              number.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        );
      },
      itemCount: 9,
    );
  }

  Widget buildUndoButton() {
    // 실행 취소 버튼
    return ElevatedButton(
      onPressed: () {
        setState(() {
          undoLastAction();
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0.5),
      ),
      child: const Text(
        '실행취소',
        style: TextStyle(fontSize: 7),
      ),
    );
  }

  Widget buildClearButton() {
    // 지우기 버튼
    return ElevatedButton(
      onPressed: () {
        setState(() {
          eraseMode = !eraseMode;
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0.5),
        backgroundColor:
            eraseMode ? const Color.fromARGB(255, 217, 217, 217) : null,
      ),
      child: const Text(
        '지우기',
        style: TextStyle(fontSize: 7),
      ),
    );
  }

  Widget buildNewGameButton() {
    // 새 게임 버튼
    return ElevatedButton(
      onPressed: () {
        setState(() {
          fetchSudokuData();
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0.0),
      ),
      child: const Text(
        '새 게임',
        style: TextStyle(fontSize: 7),
      ),
    );
  }

  Widget buildCheckButton() {
    // 정답 확인 버튼
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (const DeepCollectionEquality()
              .equals(sudokuAnswerBoard, sudokuBoard)) {
            endTime = DateTime.now();
            clearTime = endTime.difference(startTime);
            // var hours = clearTime.inHours;
            // var minutes = clearTime.inMinutes.remainder(60);
            // var seconds = clearTime.inSeconds.remainder(60);
            // var milliseconds = clearTime.inMilliseconds.remainder(1000);
            // formattedTime = '${hours}:${minutes}:${seconds}:${milliseconds}';

            showSuccessDialog();
            sendClearTime();
          } else {
            showFailDialog();
          }
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0.0),
      ),
      child: const Text(
        '답 확인하기',
        style: TextStyle(fontSize: 7),
      ),
    );
  }

  Widget buildcompleteButton() {
    // 자동 정답 완성 버튼
    return ElevatedButton(
      onPressed: () {
        setState(() {
          fillSudokuBoard(sudokuAnswerBoard);
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0.0),
      ),
      child: const Text(
        '자동 완성',
        style: TextStyle(fontSize: 7),
      ),
    );
  }

  Widget buildButtonRow(List<Widget> buttons, double buttonSize) {
    // 기능 버튼들 배치하는 함수
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: buttons.map((button) {
        return SizedBox(
          width: 28 * buttonSize,
          child: button,
        );
      }).toList(),
    );
  }

  void undoLastAction() {
    // 실행 취소 기능 함수
    if (history.isNotEmpty) {
      final lastAction = history.removeLast();
      final row = lastAction.row;
      final col = lastAction.col;
      final value = lastAction.value;

      sudokuBoard[row][col] = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    // build(전체 요소들 배치)
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Sudoku Game'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(
            //   width: 100,
            // ),
            SizedBox(
              width: 270,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSudokuBoard(),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildNumberPad(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SudokuGame(),
    );
  }
}

class HistoryItem {
  // 실행 취소를 위해 사용자의 입력을 class를 이용해 저장
  final int row;
  final int col;
  final int value;

  HistoryItem(this.row, this.col, this.value);
}
