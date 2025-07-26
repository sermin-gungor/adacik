import 'dart:math';

//Oyun hücresi tanımlar
enum Cell { empty, player1, player2, obstacle } 

class Grid {
  final int size = 7; // Tahta boyutu
  final int obstacleCount = 15; // Engellerin sayısı
  late List<List<Cell>> board; //oyuncuların hamlelerini tutan liste

  //normal constructor
  Grid() {//tahtayı başlat ve engelleri yerleştir
    board = List.generate(size, (_) => List.filled(size, Cell.empty));//her hücre başlangıçta boş
    _placeObstacles();//engelleri yerleştir
  }

  //internal constructor (klonlama için kullanılır)
  Grid._internal() {//engelleri yerleştirilmemiş boş bir tahta oluşturur
    board = List.generate(size, (_) => List.filled(size, Cell.empty));
  }

  //klonlanmış bir grid döndürür
  Grid clone() {
    Grid newGrid = Grid._internal();//yeni bir boş grid oluştur
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        newGrid.board[i][j] = board[i][j];//mevcut grid'in hücrelerini yeni grid'e kopyala
      }
    }
    return newGrid;
  }

  //belirtilen hücre boş mu?
  bool isEmpty(int row, int col) {
    return board[row][col] == Cell.empty;
  }

  //tüm hücreler dolu mu?
  bool isFull() {
    for (var row in board) {
      if (row.contains(Cell.empty)) return false;//eğer herhangi bir hücre boşsa, tahta dolu değildir
    }
    return true;
  }

  //geçerli hamle mi?
  bool isValidMove(int row, int col) {
    return row >= 0 &&
        col >= 0 &&
        row < size &&
        col < size &&
        board[row][col] == Cell.empty;
  }

  void placeMove(int row, int col, Cell player) {//hamle geçerliyse oyuncunun hamlesini yerleştir
    if (isValidMove(row, col)) {
      board[row][col] = player;
    }
  }

  //ai kodunda kullanmak için placeMove fonksiyonunun kısa ve kolay çağrılan bir takma adı
  void place(int row, int col, Cell player) {
    placeMove(row, col, player);
  }

  /// Rastgele engel yerleştir
  void _placeObstacles() {
    int placed = 0;
    final rand = Random();//rastgele sayı üret
    while (placed < obstacleCount) {
      int row = rand.nextInt(size);
      int col = rand.nextInt(size);
      if (board[row][col] == Cell.empty) {//boş hücreye engel yerleştir
        board[row][col] = Cell.obstacle;
        placed++;
      }
    }
  }

  //tahtayı konsola numaralı şekilde yazdır
  void printBoard() {
    //sütun numaralarını yaz
    String columnNumbers = '   ';
    for (int col = 0; col < size; col++) {
      columnNumbers += '$col ';
    }
    print(columnNumbers);

    //her satırı yaz
    for (int row = 0; row < size; row++) {
      String rowString = '$row  ';
      for (int col = 0; col < size; col++) {
        switch (board[row][col]) {
          case Cell.empty:
            rowString += '. ';//boş hücre için nokta kullan
            break;
          case Cell.player1:
            rowString += 'X ';//player1 için X kullan
            break;
          case Cell.player2:
            rowString += 'O ';//player2 için O kullan
            break;
          case Cell.obstacle:
            rowString += '# ';//engel için # kullan
            break;
        }
      }
      print(rowString);//her satırı yazdır
    }
  }
}
