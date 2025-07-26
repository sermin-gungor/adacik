import 'dart:io';
import 'grid.dart';
import 'utils.dart';
import 'minimax.dart';

class GameController {
  final Grid grid = Grid(); //oyun tahtası
  late MinimaxAI ai; //minimax algoritmasını kullanacak AI

  GameController() {
    ai = MinimaxAI(grid); //yapay zekayı grid ile başlat
  }

  void start() {
    bool isPlayerTurn = true; //oyuncunun sırası ise başla

    while (!_isGameOver()) {
      //oyun bitene kadar devam et
      if (isPlayerTurn) {
        //oyuncunun sırası ise
        grid.printBoard(); //tahtayı yazdır
        print("Sıra sende (X):");
        _playerMove(); //oyuncunun hamlesini al
      } else {
        //bilgisayarın sırası ise
        print("Bilgisayar düşünüyor...");
        ai.makeBestMove(); //si en iyi hamleyi yap
      }

      isPlayerTurn = !isPlayerTurn; //hamle sırasını değiştir
    }

    grid.printBoard(); //tahtayı son halini yazdır
    int playerScore =
        Utils.calculateScore(grid, Cell.player1); //oyuncunun skorunu hesapla
    int aiScore =
        Utils.calculateScore(grid, Cell.player2); //bilgisayarın skorunu hesapla
    print("Oyun Bitti!");

    if (Utils.hasConnectedSeven(grid, Cell.player1)) {
      //oyuncu 7'lik bağlantılı grup oluşturduysa
      print("Oyuncu 7'lik bağlantılı grup oluşturdu!");
    } else if (Utils.hasConnectedSeven(grid, Cell.player2)) {
      //bilgisayar 7'lik bağlantılı grup oluşturduysa
      print("Bilgisayar 7'lik bağlantılı grup oluşturdu!");
    }

    print("Senin Skorun: $playerScore");
    print("Bilgisayarın Skoru: $aiScore");

    if (playerScore > aiScore) {
      //oyuncunun skoru bilgisayarın skorundan yüksekse
      print("Kazandın!");
    } else if (playerScore < aiScore) {
      //oyuncunun skoru bilgisayarın skorundan düşükse
      print("Kaybettin!");
    } else {
      print("Berabere!"); //oyuncunun ve bilgisayarın skoru eşitse
    }
  }

  void _playerMove() {
    //oyuncunun hamlesini al
    while (true) {
      stdout.write("Satır (0-${grid.size - 1}): "); //satır numarasını al
      int row = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

      stdout.write("Sütun (0-${grid.size - 1}): "); //sütun numarasını al
      int col = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

      if (grid.isValidMove(row, col)) {
        //geçerli bir hamle ise
        grid.placeMove(row, col, Cell.player1); //hamleyi tahtaya yerleştir
        break;
      } else {
        //geçersiz hamle ise
        print("Geçersiz hamle, tekrar dene.");
      }
    }
  }

  bool _isGameOver() {
    //7'lik bağlantılı grup varsa oyun bitsin
    if (Utils.hasConnectedSeven(grid, Cell.player1) ||
        Utils.hasConnectedSeven(grid, Cell.player2)) {
      return true;
    }

    //tüm hücreler dolduysa oyun bitsin
    for (var row in grid.board) {
      for (var cell in row) {
        if (cell == Cell.empty) return false;
      }
    }
    return true;
  }
}
