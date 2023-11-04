import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SudokuGame extends StatefulWidget {
  const SudokuGame({super.key});

  @override
  _SudokuGameState createState() => _SudokuGameState();
}

class _SudokuGameState extends State<SudokuGame> {
  late List<List<int>> sudokuBoard; // 스도쿠 게임 보드
  int selectedNumber = -1; // 숫자패드에서 선택된 숫자
  bool eraseMode = false; // 지우기 모드
  List<HistoryItem> history = []; // 실행 취소를 위해 과거 입력들 저장하는 리스트

  @override
  void initState() {
    // 초기화
    super.initState();
    sudokuBoard = List.generate(9, (_) => List<int>.filled(9, 0));
    fetchSudokuData();
  }

  void fillSudokuBoard(List<List<int>> sudokuData) {
    // 스도쿠 보드에 숫자를 채우는 함수
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        sudokuBoard[row][col] = sudokuData[row][col];
      }
    }
  }

  Future<void> fetchSudokuData() async {
    // 스도쿠 게임(list) 불러오는 함수
    final response = await http.post(
      Uri.parse('http://localhost:51162/get_sudoku_arr'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final sudokuData = data['arr'];

      fillSudokuBoard(sudokuData);
    } else {
      throw Exception('Failed to fetch Sudoku data');
    }
  }

  Future<void> fetchSudokuAnswerData() async {
    // 스도쿠 정답 데이터 불러오는 함수
    final response = await http.post(
      Uri.parse('http://localhost:51162/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final AnswerData = data['answer'];

      fillSudokuBoard(AnswerData);
    } else {
      throw Exception('Failed to fetch Sudoku data');
    }
  }

  Future<void> fetchIsSuccess() async {
    // 스도쿠 정답 확인 함수
    final response = await http.post(
      Uri.parse('http://localhost:51162/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({"sudokuData": sudokuBoard}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['Success'] == 'Success') {
        // 성공했을 때 이벤트
      } else {
        // 실패했을 때 이벤트
      }
    } else {
      throw Exception('Failed to check Success');
    }
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
                    sudokuBoard[row][col] = 0;
                  } else if (selectedNumber != -1) {
                    history.add(HistoryItem(row, col, sudokuBoard[row][col]));
                    sudokuBoard[row][col] = selectedNumber;
                  }
                });
              },
              child: Container(
                width: 40,
                height: 40,
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
                  style: const TextStyle(fontSize: 20),
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
        buildButtonRow([buildCheckButton()], 2.0),
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
            width: 35,
            height: 35,
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
        padding: const EdgeInsets.all(0.0),
      ),
      child: const Text(
        '실행 취소',
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
        padding: const EdgeInsets.all(0.0),
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
          // fetchSudokuData();
          sudokuBoard = List.generate(9, (_) => List<int>.filled(9, 0));
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
          //추가
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0.0),
      ),
      child: const Text(
        '답 확인하기',
        style: TextStyle(fontSize: 10),
      ),
    );
  }

  Widget buildButtonRow(List<Widget> buttons, double buttonSize) {
    // 기능 버튼들 배치하는 함수
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: buttons.map((button) {
        return SizedBox(
          width: 30 * buttonSize,
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
      appBar: AppBar(
        title: const Text('Sudoku Game'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSudokuBoard(),
                ],
              ),
            ),
            const SizedBox(
              width: 110,
            ),
            SizedBox(
              width: 110,
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
