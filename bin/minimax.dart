import 'dart:math';
import 'grid.dart';
import 'utils.dart';

class MinimaxAI {
  final Grid grid;
  final int maxDepth;

  MinimaxAI(this.grid, {this.maxDepth = 5}); // derinlik ayarlanabilir

  void makeBestMove() {
    int bestScore = -999999;
    int? bestRow;
    int? bestCol;

    for (int i = 0; i < grid.size; i++) {
      for (int j = 0; j < grid.size; j++) {
        if (grid.isValidMove(i, j)) {
          grid.placeMove(i, j, Cell.player2);
          int score = minimax(grid, 0, false);
          grid.board[i][j] = Cell.empty;

          if (score > bestScore) {
            bestScore = score;
            bestRow = i;
            bestCol = j;
          }
        }
      }
    }

    if (bestRow != null && bestCol != null) {
      grid.placeMove(bestRow, bestCol, Cell.player2);
      print("AI $bestRow, $bestCol hamlesini yaptı (skor: $bestScore)");
    }
  }

  int minimax(Grid board, int depth, bool isMaximizingPlayer) {
    if (depth >= maxDepth || _isGameOver(board)) {
      return _evaluate(board);
    }

    int bestScore = isMaximizingPlayer ? -999999 : 999999;

    for (int i = 0; i < board.size; i++) {
      for (int j = 0; j < board.size; j++) {
        if (board.isValidMove(i, j)) {
          Cell currentPlayer = isMaximizingPlayer ? Cell.player2 : Cell.player1;
          board.placeMove(i, j, currentPlayer);

          int score = minimax(board, depth + 1, !isMaximizingPlayer);

          board.board[i][j] = Cell.empty;

          if (isMaximizingPlayer) {
            bestScore = max(bestScore, score);
          } else {
            bestScore = min(bestScore, score);
          }
        }
      }
    }

    return bestScore;
  }

  int _evaluate(Grid board) {
    int aiScore = Utils.calculateScore(board, Cell.player2);
    int playerScore = Utils.calculateScore(board, Cell.player1);
    return aiScore - playerScore;
  }

  bool _isGameOver(Grid board) {
    for (var row in board.board) {
      for (var cell in row) {
        if (cell == Cell.empty) return false;
      }
    }
    return true;
  }
}
