import 'dart:math';

/// Oyun hücresi türleri
enum Cell { empty, player1, player2, obstacle }

class Grid {
  final int size = 5;
  final int obstacleCount = 5;
  late List<List<Cell>> board;

  // Normal constructor
  Grid() {
    board = List.generate(size, (_) => List.filled(size, Cell.empty));
    _placeObstacles();
  }

  // Internal constructor (klonlama için kullanılır)
  Grid._internal() {
    board = List.generate(size, (_) => List.filled(size, Cell.empty));
  }

  /// Klonlanmış bir Grid döndürür
  Grid clone() {
    Grid newGrid = Grid._internal();
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        newGrid.board[i][j] = board[i][j];
      }
    }
    return newGrid;
  }

  /// Belirtilen hücre boş mu?
  bool isEmpty(int row, int col) {
    return board[row][col] == Cell.empty;
  }

  /// Tüm hücreler dolu mu?
  bool isFull() {
    for (var row in board) {
      if (row.contains(Cell.empty)) return false;
    }
    return true;
  }

  /// Geçerli hamle mi?
  bool isValidMove(int row, int col) {
    return row >= 0 &&
        col >= 0 &&
        row < size &&
        col < size &&
        board[row][col] == Cell.empty;
  }

  /// Belirtilen hücreye oyuncu yerleştir
  void placeMove(int row, int col, Cell player) {
    if (isValidMove(row, col)) {
      board[row][col] = player;
    }
  }

  /// AI için minimax algoritmasına uyumlu `place` alias'ı
  void place(int row, int col, Cell player) {
    placeMove(row, col, player);
  }

  /// Rastgele engel yerleştir
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

  /// Tahtayı konsola yazdır
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
