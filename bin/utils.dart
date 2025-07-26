import 'grid.dart';

class Utils {
  static int calculateScore(Grid grid, Cell player) {//belitilen oyuncuya ait bölgeleri gezerek skoru hesaplar
  //her bölgenin skoru karesi alınarak hesaplanır
    int score = 0;
    Set<String> visited = {};

    for (int row = 0; row < grid.size; row++) {
      for (int col = 0; col < grid.size; col++) {
        if (grid.board[row][col] == player && !visited.contains('$row,$col')) {//oyuncuya ait ve daha önce ziyaret edilmemiş hücre bulunduysa
          int regionSize = _dfs(grid, row, col, player, visited);//bölge boyutunu bul
          score += regionSize * regionSize;//skora bölge boyutunun karesini ekle  
        }
      }
    }

    return score;
  }

  static int _dfs(//dfs ile bölge boyutu bulunur
      Grid grid, int row, int col, Cell player, Set<String> visited) {
    if (row < 0 || row >= grid.size || col < 0 || col >= grid.size) return 0;//sınır kontrolü
    if (grid.board[row][col] != player) return 0;//oyuncuya ait değilse 0 döndür
    if (visited.contains('$row,$col')) return 0;//daha önce ziyaret edilmişse 0 döndür

    visited.add('$row,$col');//ziyaret edilen hücreyi ekle

    int size = 1;
    size += _dfs(grid, row + 1, col, player, visited); // aşağı
    size += _dfs(grid, row - 1, col, player, visited); // yukarı
    size += _dfs(grid, row, col + 1, player, visited); // sağ
    size += _dfs(grid, row, col - 1, player, visited); // sol

    return size;
  }

//7 bağlantılı hücre var mı?
  static bool hasConnectedSeven(Grid grid, Cell player) {
    Set<String> visited = {};

    for (int row = 0; row < grid.size; row++) {
      for (int col = 0; col < grid.size; col++) {
        if (grid.board[row][col] == player && !visited.contains('$row,$col')) {
          int size = _dfs(grid, row, col, player, visited);
          if (size >= 7) {
            return true;
          }
        }
      }
    }

    return false;
  }
}
