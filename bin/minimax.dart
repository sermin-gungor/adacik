// minimax.dart
import 'grid.dart';
import 'utils.dart';

class MinimaxAI {
  final Grid grid;

  MinimaxAI(this.grid);

  void makeMove() {
    int? bestRow;
    int? bestCol;
    int bestScore = -99999;

    for (int i = 0; i < grid.size; i++) {
      for (int j = 0; j < grid.size; j++) {
        if (grid.isValidMove(i, j)) {
          grid.placeMove(i, j, Cell.player2);
          int score = Utils.calculateScore(grid, Cell.player2) - Utils.calculateScore(grid, Cell.player1);
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
      print("Bilgisayar hamlesi: $bestRow, $bestCol");
    }
  }
}
