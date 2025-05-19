// utils.dart
import 'grid.dart';

class Utils {
  static int calculateScore(Grid grid, Cell player) {
    final visited = List.generate(grid.size, (_) => List.filled(grid.size, false));
    int totalScore = 0;

    for (int i = 0; i < grid.size; i++) {
      for (int j = 0; j < grid.size; j++) {
        if (grid.board[i][j] == player && !visited[i][j]) {
          int groupSize = _dfs(grid, i, j, visited, player);
          totalScore += groupSize * groupSize;
        }
      }
    }

    return totalScore;
  }

  static int _dfs(Grid grid, int row, int col, List<List<bool>> visited, Cell player) {
    if (row < 0 || col < 0 || row >= grid.size || col >= grid.size) return 0;
    if (visited[row][col] || grid.board[row][col] != player) return 0;

    visited[row][col] = true;
    int count = 1;

    count += _dfs(grid, row + 1, col, visited, player);
    count += _dfs(grid, row - 1, col, visited, player);
    count += _dfs(grid, row, col + 1, visited, player);
    count += _dfs(grid, row, col - 1, visited, player);

    return count;
  }
}
