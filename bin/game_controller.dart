// game_controller.dart
import 'dart:io';
import 'grid.dart';
import 'utils.dart';
import 'minimax.dart';

class GameController {
  final Grid grid = Grid();
  late MinimaxAI ai;

  GameController() {
    ai = MinimaxAI(grid);
  }

  void start() {
    bool isPlayerTurn = true;

    while (!_isGameOver()) {
      grid.printBoard();
      if (isPlayerTurn) {
        print("Sıra sende (X):");
        _playerMove();
      } else {
        print("Bilgisayar düşünüyor...");
        ai.makeBestMove(); 
();
      }

      isPlayerTurn = !isPlayerTurn;
    }

    grid.printBoard();
    int playerScore = Utils.calculateScore(grid, Cell.player1);
    int aiScore = Utils.calculateScore(grid, Cell.player2);
    print("Oyun Bitti!");
    print("Senin Skorun: $playerScore");
    print("Bilgisayarın Skoru: $aiScore");

    if (playerScore > aiScore) {
      print("Kazandın! 🎉");
    } else if (playerScore < aiScore) {
      print("Kaybettin! 😢");
    } else {
      print("Berabere! 🤝");
    }
  }

  void _playerMove() {
    while (true) {
      stdout.write("Satır (0-${grid.size - 1}): ");
      int row = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

      stdout.write("Sütun (0-${grid.size - 1}): ");
      int col = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

      if (grid.isValidMove(row, col)) {
        grid.placeMove(row, col, Cell.player1);
        break;
      } else {
        print("Geçersiz hamle, tekrar dene.");
      }
    }
  }

  bool _isGameOver() {
    for (var row in grid.board) {
      for (var cell in row) {
        if (cell == Cell.empty) return false;
      }
    }
    return true;
  }
}
