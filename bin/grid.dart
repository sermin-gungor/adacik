// grid.dart
import 'dart:math';

enum Cell { empty, player1, player2, obstacle }

class Grid {
  final int size = 5;
  final int obstacleCount = 4;
  late List<List<Cell>> board;

  Grid() {
    board = List.generate(size, (_) => List.filled(size, Cell.empty));
    _placeObstacles();
  }

  void _placeObstacles() {
    int placed = 0;
    final rand = Random();
    while (placed < obstacleCount) {
      int row = rand.nextInt(size);
      int col = rand.nextInt(size);
      if (board[row][col] == Cell.empty) {
        board[row][col] = Cell.obstacle;
        placed++;
      }
    }
  }

  bool isValidMove(int row, int col) {
    return row >= 0 &&
        col >= 0 &&
        row < size &&
        col < size &&
        board[row][col] == Cell.empty;
  }

  void placeMove(int row, int col, Cell player) {
    if (isValidMove(row, col)) {
      board[row][col] = player;
    }
  }

  void printBoard() {
    for (var row in board) {
      print(row.map((cell) {
        switch (cell) {
          case Cell.empty:
            return '.';
          case Cell.player1:
            return 'X';
          case Cell.player2:
            return 'O';
          case Cell.obstacle:
            return '#';
        }
      }).join(' '));
    }
  }
}
