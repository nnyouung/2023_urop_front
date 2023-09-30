import 'package:flutter/material.dart';

class SudokuGame extends StatefulWidget {
  const SudokuGame({super.key});

  // const SudokuGame({super.key});
  @override
  _SudokuGameState createState() => _SudokuGameState();
}

class _SudokuGameState extends State<SudokuGame> {
  late List<List<int>> sudokuBoard; // 스도쿠 보드 상태를 나타내는 2D 리스트
  int selectedNumber = -1; // 선택된 숫자 초기값은 -1
  int selectedRow = -1; // 선택된 행 초기값은 -1
  int selectedCol = -1; // 선택된 열 초기값은 -1

  @override
  void initState() {
    super.initState();
    // 스도쿠 보드 생성 (0은 빈 칸)
    sudokuBoard = List.generate(9, (_) => List<int>.filled(9, 0));
  }

  // 스도쿠 판에 숫자를 그리는 함수
  Widget buildSudokuBoard() {
    return Column(
      children: List.generate(9, (row) {
        return Row(
          children: List.generate(9, (col) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedNumber != -1) {
                    // 선택한 숫자로 게임 보드의 셀의 숫자를 변경
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
                      ? const Color.fromARGB(
                          255, 232, 232, 232) // 선택된 셀은 아주 옅은 회색으로 색상 변경
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

  // 숫자 패드를 그리는 함수
  Widget buildNumberPad() {
    return Column(
      children: [
        buildButtonRow(
            [buildUndoButton(), buildClearButton(), buildNewGameButton()], 1.0),
        const SizedBox(height: 20),
        buildNumberGrid(), // 숫자 패드 그리기
        const SizedBox(height: 20),
        buildButtonRow([buildCheckButton()], 2.0),
      ],
    );
  }

  // 숫자 패드 그리는 함수
  Widget buildNumberGrid() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        final number = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedNumber = number; // 선택된 숫자 업데이트
            });
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(),
              color: selectedNumber == number
                  ? Colors.grey[200]
                  : Colors.white, // 선택된 숫자는 회색으로 색상 변경
              shape: BoxShape.rectangle, // 사각형 모양 버튼
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

  // 실행 취소 버튼을 만드는 함수
  Widget buildUndoButton() {
    return ElevatedButton(
      onPressed: () {
        // 실행 취소 버튼 눌렀을 때의 동작 추가 부분
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

  // 지우기 버튼을 만드는 함수
  Widget buildClearButton() {
    return ElevatedButton(
      onPressed: () {
        // 지우기 버튼 눌렀을 때의 동작 추가 부분
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0.0),
      ),
      child: const Text(
        '지우기',
        style: TextStyle(fontSize: 7),
      ),
    );
  }

  // 새 게임 버튼을 만드는 함수
  Widget buildNewGameButton() {
    return ElevatedButton(
      onPressed: () {
        // 새 게임 버튼 눌렀을 때의 동작 추가
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0.0), //
      ),
      child: const Text(
        '새 게임',
        style: TextStyle(fontSize: 7),
      ),
    );
  }

  // 답 확인하기 버튼을 만드는 함수
  Widget buildCheckButton() {
    return ElevatedButton(
      onPressed: () {
        // 답 확인하기 버튼 눌렀을 때의 동작 추가 부분
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

  // 버튼들을 가로로 배치하는 함수
  Widget buildButtonRow(List<Widget> buttons, double buttonSize) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku Game'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSudokuBoard(),
                ],
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            SizedBox(
              width: 90, // 숫자 패드 폭
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
