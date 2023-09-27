// 주석을 추가 하긴 했는데 별로 추가 할게 없네요. 혹시라도 물어 보고 싶은거 있으면 친절히 알려드릴게유
// 버튼 기능은 해보려고 했는데 백엔드와 협의도 해야할 것 같고, a little 생각할 시간이 필요해서 수정하고 말씀드릴게유~
// 항상 행복하시고 즐거운 추석 되세요~~
//   d====^o^====b S2
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

  // 스도쿠 보드(판)을 띄우고, 선택한 숫자를 그리는 함수
  Widget buildSudokuBoard() {
    return Column(
      children: List.generate(9, (row) {
        return Row(
          children: List.generate(9, (col) {
            return GestureDetector(
              // 숫자를 선택하고 셀을 선택했을때 이벤트를 발생시킴
              onTap: () {
                setState(() {
                  if (selectedNumber != -1) {
                    // 선택한 숫자로 게임 보드의 셀의 숫자를 변경
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
                      ? const Color.fromARGB(255, 232, 232,
                          232) // 스도쿠 판의 디자인을 격자 무늬로 하기 위해 특정 셀을 옅은 회색으로 색상 변경
                      : Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  sudokuBoard[row][col] !=
                          0 // 스도쿠 보드의 숫자가 0이면 빈칸, 0이 아니면 해당 숫자로 출력되어 스도쿠 보드에 출력
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

  // 버튼 배치하는 함수
  Widget buildButtons() {
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
              selectedNumber = number; // 숫자 패드의 셀을 클릭하면 클릭한 숫자로 선택된 숫자 변수를 업데이트
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
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          side: const BorderSide(color: Color.fromARGB(255, 174, 174, 174))),
      child: const Text(
        '실행 취소',
        style: TextStyle(fontSize: 9),
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
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          side: const BorderSide(color: Color.fromARGB(255, 174, 174, 174))),
      child: const Text(
        '지우기',
        style: TextStyle(fontSize: 9),
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
          padding: const EdgeInsets.all(0.0),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          side: const BorderSide(color: Color.fromARGB(255, 174, 174, 174))),
      child: const Text(
        '새 게임',
        style: TextStyle(fontSize: 9),
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
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          side: const BorderSide(color: Color.fromARGB(255, 174, 174, 174))),
      child: const Text(
        '답 확인하기',
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  // 버튼들을 가로로 배치하는 함수
  Widget buildButtonRow(List<Widget> buttons, double buttonSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: buttons.map((button) {
        return SizedBox(
          width: 40 * buttonSize,
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
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSudokuBoard(),
                ],
              ),
            ),
            const SizedBox(
              width: 120,
            ),
            SizedBox(
              width: 150, // 숫자 패드 폭
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
