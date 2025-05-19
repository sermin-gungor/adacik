import 'grid.dart';

class Utils {
  static int calculateScore(Grid grid, Cell player) {
    int score = 0;
    Set<String> visited = {};

    for (int row = 0; row < grid.size; row++) {
      for (int col = 0; col < grid.size; col++) {
        if (grid.board[row][col] == player && !visited.contains('$row,$col')) {
          int regionSize = _dfs(grid, row, col, player, visited);
          score += regionSize * regionSize;
        }
      }
    }

    return score;
  }

  static int _dfs(
      Grid grid, int row, int col, Cell player, Set<String> visited) {
    if (row < 0 || row >= grid.size || col < 0 || col >= grid.size) return 0;
    if (grid.board[row][col] != player) return 0;
    if (visited.contains('$row,$col')) return 0;

    visited.add('$row,$col');

    int size = 1;
    size += _dfs(grid, row + 1, col, player, visited); // aşağı
    size += _dfs(grid, row - 1, col, player, visited); // yukarı
    size += _dfs(grid, row, col + 1, player, visited); // sağ
    size += _dfs(grid, row, col - 1, player, visited); // sol

    return size;
  }
}
