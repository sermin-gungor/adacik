import 'dart:io';
import 'dart:math';

const int gridSize = 4;
const int totalObstacles = 5;

enum Cell { empty, obstacle, player1, player2 }

List<List<Cell>> board =
    List.generate(gridSize, (_) => List.generate(gridSize, (_) => Cell.empty));

void main() {
  placeObstacles();
  printBoard();

  bool player1Turn = true;

  while (true) {
    if (isBoardFull()) break;

    if (player1Turn) {
      print("Oyuncu (senin) sırası. Satır ve sütun gir (0-6):");
      int row = int.parse(stdin.readLineSync()!);
      int col = int.parse(stdin.readLineSync()!);

      if (!isValidMove(row, col)) {
        print("Geçersiz hamle. Tekrar dene.");
        continue;
      }

      board[row][col] = Cell.player1;
    } else {
      print("Bilgisayarın sırası.");
      makeAIMove();
    }

    printBoard();
    player1Turn = !player1Turn;
  }

  final player1Score = calculateScore(Cell.player1);
  final player2Score = calculateScore(Cell.player2);

  print("Oyun bitti!");
  print("Senin puanın: $player1Score");
  print("Bilgisayarın puanı: $player2Score");

  if (player1Score > player2Score) {
    print("Tebrikler, kazandın!");
  } else if (player1Score < player2Score) {
    print("Bilgisayar kazandı!");
  } else {
    print("Berabere!");
  }
}

// ----------------------------------------

void placeObstacles() {
  Random rand = Random();
  int count = 0;
  while (count < totalObstacles) {
    int row = rand.nextInt(gridSize);
    int col = rand.nextInt(gridSize);
    if (board[row][col] == Cell.empty) {
      board[row][col] = Cell.obstacle;
      count++;
    }
  }
}

void printBoard() {
  print("\nOyun Tahtası:");
  for (int i = 0; i < gridSize; i++) {
    String row = '';
    for (int j = 0; j < gridSize; j++) {
      switch (board[i][j]) {
        case Cell.empty:
          row += '. ';
          break;
        case Cell.obstacle:
          row += '# ';
          break;
        case Cell.player1:
          row += 'X ';
          break;
        case Cell.player2:
          row += 'O ';
          break;
      }
    }
    print(row);
  }
}

bool isValidMove(int row, int col) {
  if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) return false;
  return board[row][col] == Cell.empty;
}

void makeAIMove() {
  Random rand = Random();
  while (true) {
    int row = rand.nextInt(gridSize);
    int col = rand.nextInt(gridSize);
    if (isValidMove(row, col)) {
      board[row][col] = Cell.player2;
      break;
    }
  }
}

bool isBoardFull() {
  for (var row in board) {
    for (var cell in row) {
      if (cell == Cell.empty) return false;
    }
  }
  return true;
}

int calculateScore(Cell player) {
  Set<String> visited = {};
  int total = 0;

  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      if (board[i][j] == player && !visited.contains('$i,$j')) {
        int regionSize = dfs(i, j, player, visited);
        total += regionSize * regionSize;
      }
    }
  }

  return total;
}

int dfs(int row, int col, Cell player, Set<String> visited) {
  if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) return 0;
  if (board[row][col] != player || visited.contains('$row,$col')) return 0;

  visited.add('$row,$col');

  return 1 +
      dfs(row + 1, col, player, visited) +
      dfs(row - 1, col, player, visited) +
      dfs(row, col + 1, player, visited) +
      dfs(row, col - 1, player, visited);
}
