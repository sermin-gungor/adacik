import 'grid.dart';
import 'utils.dart';
import 'dart:math';

class MinimaxAI {
  final Grid grid; //oyun tahtası
  final int maxDepth; //minimax algoritmasının maksimum derinliği varsayılan 4
  final Cell aiPlayer = Cell.player2; //bilgisayarın oyuncu tipi
  final Cell humanPlayer = Cell.player1; //insan oyuncunun tipi

  MinimaxAI(this.grid,
      {this.maxDepth =
          4}); //constructor Grid nesnesini ve opsiyonel maxDepth değeri alır

  void makeBestMove() {
    //en iyi hamleyi yapma fonksiyonu
    int bestScore = -999999; //en iyi skoru başta çok düşük bir değere ayarla
    List<Point> bestMoves = []; //en iyi hamleleri tutacak liste

    for (int row = 0; row < grid.size; row++) {
      //tüm hücreleri dolaş
      for (int col = 0; col < grid.size; col++) {
        if (grid.isEmpty(row, col)) {
          //eğer hücre boşsa
          Grid cloned = grid.clone(); //grid'i klonla
          cloned.place(row, col, aiPlayer);

          int score = minimax(cloned, 1, false, -999999,
              999999); //minimax algoritmasını çağır ve skoru al

          if (score > bestScore) {
            //eğer bu skor en iyisinden yüksekse
            bestScore = score; //en iyi skoru güncelle
            bestMoves = [Point(row, col)];
          } else if (score == bestScore) {
            //eğer bu skor en iyisiyle eşitse alternatif hamle ekle
            bestMoves.add(Point(row, col));
          }
        }
      }
    }
//eğer en iyi hamleler listesi boş değilse rastgele bir hamle seç ve tahtaya yerleştir
    if (bestMoves.isNotEmpty) {
      Point chosen = bestMoves[Random().nextInt(bestMoves.length)];
      grid.place(chosen.x.toInt(), chosen.y.toInt(), aiPlayer);
      print('AI played at (${chosen.x}, ${chosen.y})');
    }
  }

// Minimax algoritması
  int minimax(Grid board, int depth, bool isMaximizing, int alpha, int beta) {
    if (depth == maxDepth || board.isFull()) {
      //maksimum derinliğe ulaşıldıysa veya tahta doluysa
      return evaluate(board); //değerlendirme fonksiyonunu çağır
    }

    if (isMaximizing) {
      //eğer bilgisayarın sırasıysa
      int maxEval = -999999;

      for (int row = 0; row < board.size; row++) {
        for (int col = 0; col < board.size; col++) {
          if (board.isEmpty(row, col)) {
            Grid cloned = board.clone();
            cloned.place(row, col, aiPlayer);

            int eval = minimax(cloned, depth + 1, false, alpha,
                beta); //minimax algoritmasını çağır ve skoru al
            maxEval = maxEval > eval ? maxEval : eval; //en iyi skoru güncelle
            alpha = alpha > eval ? alpha : eval; //alfa değerini güncelle

            if (beta <= alpha) {
              return maxEval; // pruning
            }
          }
        }
      }

      return maxEval;
    } else {
      int minEval = 999999; //eğer insanın sırasıysa

      for (int row = 0; row < board.size; row++) {
        for (int col = 0; col < board.size; col++) {
          if (board.isEmpty(row, col)) {
            Grid cloned = board.clone();
            cloned.place(row, col, humanPlayer);

            int eval = minimax(cloned, depth + 1, true, alpha,
                beta); //minimax algoritmasını çağır ve skoru al
            minEval = minEval < eval ? minEval : eval; //en düşük skoru bul
            beta = beta < eval ? beta : eval; //beta değerini güncelle

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
    // değerlendirme fonksiyonu
    int aiScore = Utils.calculateScore(board, aiPlayer); // bilgisayarın skoru
    int humanScore = Utils.calculateScore(board, humanPlayer); // insanın skoru
    return aiScore -
        humanScore; // skoru bilgisayarın skoru - insanın skoru olarak hesapla
  }
}
