import 'grid.dart';
import 'utils.dart';

class MinimaxAI {
  final Grid grid;
  final int maxDepth;
  final Cell aiPlayer = Cell.player2;
  final Cell humanPlayer = Cell.player1;

  MinimaxAI(this.grid, {this.maxDepth = 4});

  void makeBestMove() {
    int bestScore = -999999;
    int bestRow = -1;
    int bestCol = -1;

    for (int row = 0; row < grid.size; row++) {
      for (int col = 0; col < grid.size; col++) {
        if (grid.isEmpty(row, col)) {
          Grid cloned = grid.clone();
          cloned.place(row, col, aiPlayer);

          int score = minimax(cloned, 1, false, -999999, 999999);

          if (score > bestScore) {
            bestScore = score;
            bestRow = row;
            bestCol = col;
          }
        }
      }
    }

    if (bestRow != -1 && bestCol != -1) {
      grid.place(bestRow, bestCol, aiPlayer);
      print('AI played at ($bestRow, $bestCol)');
    }
  }

  int minimax(Grid board, int depth, bool isMaximizing, int alpha, int beta) {
    if (depth == maxDepth || board.isFull()) {
      return evaluate(board);
    }

    if (isMaximizing) {
      int maxEval = -999999;

      for (int row = 0; row < board.size; row++) {
        for (int col = 0; col < board.size; col++) {
          if (board.isEmpty(row, col)) {
            Grid cloned = board.clone();
            cloned.place(row, col, aiPlayer);

            int eval = minimax(cloned, depth + 1, false, alpha, beta);
            maxEval = maxEval > eval ? maxEval : eval;
            alpha = alpha > eval ? alpha : eval;

            if (beta <= alpha) {
              return maxEval; // pruning
            }
          }
        }
      }

      return maxEval;
    } else {
      int minEval = 999999;

      for (int row = 0; row < board.size; row++) {
        for (int col = 0; col < board.size; col++) {
          if (board.isEmpty(row, col)) {
            Grid cloned = board.clone();
            cloned.place(row, col, humanPlayer);

            int eval = minimax(cloned, depth + 1, true, alpha, beta);
            minEval = minEval < eval ? minEval : eval;
            beta = beta < eval ? beta : eval;

            if (beta <= alpha) {
              return minEval; // pruning
            }
          }
        }
      }

      return minEval;
    }
  }

  int evaluate(Grid board) {
    int aiScore = Utils.calculateScore(board, aiPlayer);
    int humanScore = Utils.calculateScore(board, humanPlayer);
    return aiScore - humanScore;
  }
}
