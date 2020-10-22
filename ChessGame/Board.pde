class Board {
  Cell[][] chessboard;
  float spacing;
  Board() {
    chessboard = new Cell[ROWS][COLS];
    spacing = height / ROWS;
    for (int i = 0; i < ROWS; i++) {
      for (int j = 0; j < COLS; j++) {
        chessboard[i][j] = new Cell("-", (j + i) % 2, i, j, spacing);
      }
    }
    placePieces("black");
    placePieces("white");
  } 
  void placePieces(String prefix) {
    if (prefix == "white") {
      chessboard[0][0].setVal("whiterook");
      chessboard[0][1].setVal("whiteknight");
      chessboard[0][2].setVal("whitebishop");
      chessboard[0][3].setVal("whiteking");
      chessboard[0][4].setVal("whitequeen");

      chessboard[0][5].setVal("whitebishop");
      chessboard[0][6].setVal("whiteknight");
      chessboard[0][7].setVal("whiterook");
      for (int j = 0; j < 8; j++) {
        chessboard[1][j].setVal("whitepawn");
      }
    } else {
      chessboard[7][0].setVal("blackrook");
      chessboard[7][1].setVal("blackknight");
      chessboard[7][2].setVal("blackbishop");
      chessboard[7][3].setVal("blackking");
      chessboard[7][4].setVal("blackqueen");

      chessboard[7][5].setVal("blackbishop");
      chessboard[7][6].setVal("blackknight");
      chessboard[7][7].setVal("blackrook");
      for (int j = 0; j < 8; j++) {
        chessboard[6][j].setVal("blackpawn");
      }
    }
  } 
  void showBoard() {
    for (int i = 0; i < ROWS; i++) {
      for (int j = 0; j < COLS; j++) {
        chessboard[i][j].show();
      }
    }
  }
  Cell check(float mX, float mY) {
    for (int i = 0; i < ROWS; i++) {
      for (int j = 0; j < COLS; j++) {
        float x = j * spacing + spacing / 2;
        float y = i * spacing + spacing / 2;
        float d = dist(x, y, mX, mY);
        if (d <= spacing / 2) {
          return chessboard[i][j];
        }
      }
    }
    return null;
  }
  ArrayList<Cell> displayValidMoves(int cI, int cJ) {
    ArrayList<Cell> validMoves = new ArrayList<Cell>();
    if (chessboard[cI][cJ].val.indexOf("rook") != -1) { //rook's valid moves
      if (chessboard[cI][cJ].val.indexOf("black") != -1) { //black rook's turn
        validMoves = rooksMove(cI, cJ, "white");
      } else {  // white rook's turn
        validMoves = rooksMove(cI, cJ, "black");
      }
    } else if (chessboard[cI][cJ].val.indexOf("bishop") != -1) { //bishops's valid moves
      if (chessboard[cI][cJ].val.indexOf("black") != -1) { //black bishop's turn 
        validMoves = bishopsMove(cI, cJ, "white");
      } else {
        validMoves = bishopsMove(cI, cJ, "black");
      } 
    } else if (chessboard[cI][cJ].val.indexOf("king") != -1) { //king's valid moves
      if (chessboard[cI][cJ].val.indexOf("black") != -1) { //black kings's move
        validMoves = kingsMove(cI, cJ, "white");
      } else { //white kings's move 
        validMoves = kingsMove(cI, cJ, "black");
      }
    } else if (chessboard[cI][cJ].val.indexOf("queen") != -1) { //queen's valid moves
      if (chessboard[cI][cJ].val.indexOf("black") != -1) { //black queen's move
        validMoves = queensMove(cI, cJ, "white");
      } else { //white queen's move 
        validMoves = queensMove(cI, cJ, "black");
      }
    } else if (chessboard[cI][cJ].val.indexOf("knight") != -1) { //knight's valid moves
      if (chessboard[cI][cJ].val.indexOf("black") != -1) { //black knight's valid moves
        validMoves = knightsMove(cI, cJ, "white");
      } else { //white knight's valid moves 
        validMoves = knightsMove(cI, cJ, "black");
      } 
    } else if (chessboard[cI][cJ].val.indexOf("pawn") != -1) { //pawn's valid moves
      if (chessboard[cI][cJ].val.indexOf("black") != -1) { //if black pawn's turn 
        if (cI - 1 >= 0 && chessboard[cI - 1][cJ].val == "-") {
          validMoves.add(chessboard[cI - 1][cJ]);
        } 
        if (cI - 2 >= 0 && chessboard[cI - 2][cJ].val == "-" && chessboard[cI][cJ].count == 0) {
          validMoves.add(chessboard[cI - 2][cJ]);
        }
        if (cI - 1 >= 0) {
          if (cJ - 1 >= 0 && chessboard[cI - 1][cJ - 1].val.indexOf("white") != -1) {
            validMoves.add(chessboard[cI - 1][cJ - 1]);
          } 
          if (cJ + 1 < COLS && chessboard[cI - 1][cJ + 1].val.indexOf("white") != -1) {
            validMoves.add(chessboard[cI - 1][cJ + 1]);
          }
        }
      } else { //if white pawn's turn 
        if (cI + 1 < ROWS && chessboard[cI + 1][cJ].val == "-") {
          validMoves.add(chessboard[cI + 1][cJ]);
        } 
        if (cI + 2 < ROWS && chessboard[cI + 2][cJ].val == "-" && chessboard[cI][cJ].count == 0) {
          validMoves.add(chessboard[cI + 2][cJ]);
        } 
        if (cI + 1 < ROWS) {
          if (cJ - 1 >= 0 && chessboard[cI + 1][cJ - 1].val.indexOf("black") != -1) {
            validMoves.add(chessboard[cI + 1][cJ - 1]);
          } 
          if (cJ + 1 < COLS && chessboard[cI + 1][cJ + 1].val.indexOf("black") != -1) {
            validMoves.add(chessboard[cI + 1][cJ + 1]);
          }
        }
      }
    }
    return validMoves;
  }
  ArrayList<Cell> bishopsMove(int cI, int cJ, String opponent) {
    ArrayList<Cell> validMoves = new ArrayList<Cell>();
    for (int i = cI - 1, j = cJ - 1; i >= 0 && j >= 0; i--, j--) {
      if (chessboard[i][j].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[i][j]);
        break;
      } 
      if (chessboard[i][j].val != "-") {
        break;
      } 
      validMoves.add(chessboard[i][j]);
    } 
    for (int i = cI - 1, j = cJ + 1; i >= 0 && j < COLS; i--, j++) {
      if (chessboard[i][j].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[i][j]);
        break;
      } 
      if (chessboard[i][j].val != "-") {
        break;
      } 
      validMoves.add(chessboard[i][j]);
    } 
    for (int i = cI + 1, j = cJ + 1; i < ROWS && j < COLS; i++, j++) {
      if (chessboard[i][j].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[i][j]);
        break;
      } 
      if (chessboard[i][j].val != "-") {
        break;
      } 
      validMoves.add(chessboard[i][j]);
    }
    for (int i = cI + 1, j = cJ - 1; i < ROWS && j >= 0; i++, j--) {
      if (chessboard[i][j].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[i][j]);
        break;
      } 
      if (chessboard[i][j].val != "-") {
        break;
      } 
      validMoves.add(chessboard[i][j]);
    }
    return validMoves;
  } 
  ArrayList<Cell> knightsMove(int cI, int cJ, String opponent) {
    ArrayList<Cell> validMoves = new ArrayList<Cell>();
    //2 steps left and 1 step up
    if (cJ >= 2 && cI >= 1) {
      if (chessboard[cI - 1][cJ - 2].val == "-" || chessboard[cI - 1][cJ - 2].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[cI - 1][cJ - 2]);
      } 
    } 
    //2 steps left and 1 step down
    if (cJ >= 2 && cI < ROWS - 1) {
      if (chessboard[cI + 1][cJ - 2].val == "-" || chessboard[cI + 1][cJ - 2].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[cI + 1][cJ - 2]);
      } 
    } 
    //2 steps up and 1 step left
    if (cJ >= 1 && cI >= 2) {
      if (chessboard[cI - 2][cJ - 1].val == "-" || chessboard[cI - 2][cJ - 1].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[cI - 2][cJ - 1]);
      } 
    } 
    //2 steps up and 1 step right
    if (cJ < COLS - 1 && cI >= 2) {
      if (chessboard[cI - 2][cJ + 1].val == "-" || chessboard[cI - 2][cJ + 1].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[cI - 2][cJ + 1]);
      } 
    } 
    
    //2 steps right and 1 step up
    if (cJ < COLS - 2 && cI >= 1) {
      if (chessboard[cI - 1][cJ + 2].val == "-" || chessboard[cI - 1][cJ + 2].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[cI - 1][cJ + 2]);
      } 
    } 
    //2 steps right and 1 step down
    if (cJ < COLS - 2 && cI < ROWS - 1) {
      if (chessboard[cI + 1][cJ + 2].val == "-" || chessboard[cI + 1][cJ + 2].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[cI + 1][cJ + 2]);
      } 
    } 
    //2 steps down and 1 step left
    if (cJ >= 1 && cI < ROWS - 2) {
      if (chessboard[cI + 2][cJ - 1].val == "-" || chessboard[cI + 2][cJ - 1].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[cI + 2][cJ - 1]);
      } 
    } 
    //2 steps down and 1 step right
    if (cJ < COLS - 1 && cI < ROWS - 2) {
      if (chessboard[cI + 2][cJ + 1].val == "-" || chessboard[cI + 2][cJ + 1].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[cI + 2][cJ + 1]);
      } 
    } 
    return validMoves;
  } 
  ArrayList<Cell> rooksMove(int cI, int cJ, String opponent) {
    ArrayList<Cell> validMoves = new ArrayList<Cell>();
    //horizontal move
    for (int j = cJ - 1; j >= 0; j--) {
      if (chessboard[cI][j].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[cI][j]);
        break;
      }
      if (chessboard[cI][j].val != "-") {
        break;
      } 
      validMoves.add(chessboard[cI][j]);
    } 
    for (int j = cJ + 1; j < COLS; j++) {
      if (chessboard[cI][j].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[cI][j]);
        break;
      } 
      if (chessboard[cI][j].val != "-") {
        break;
      } 
      validMoves.add(chessboard[cI][j]);
    }
    //vertical move 
    for (int i = cI - 1; i >= 0; i--) {
      if (chessboard[i][cJ].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[i][cJ]);
        break;
      } 
      if (chessboard[i][cJ].val != "-") {
        break;
      } 
      validMoves.add(chessboard[i][cJ]);
    } 
    for (int i = cI + 1; i < ROWS; i++) {
      if (chessboard[i][cJ].val.indexOf(opponent) != -1) {
        validMoves.add(chessboard[i][cJ]);
        break;
      } 
      if (chessboard[i][cJ].val != "-") {
        break;
      } 
      validMoves.add(chessboard[i][cJ]);
    }
    return validMoves;
  }
  ArrayList<Cell> queensMove(int cI, int cJ, String opponent) {
    ArrayList<Cell> rooksValidMoves = rooksMove(cI, cJ, opponent);
    ArrayList<Cell> bishopsValidMoves = bishopsMove(cI, cJ, opponent);
    bishopsValidMoves.addAll(rooksValidMoves);
    return bishopsValidMoves;
  } 
  ArrayList<Cell> kingsMove(int cI, int cJ, String opponent) {
    ArrayList<Cell> validMoves = new ArrayList<Cell>();
    for (int ioff = -1; ioff <= 1; ioff++) {
      for (int joff = -1; joff <= 1; joff++) {
        if (joff == 0 && ioff == 0) {
          continue;
        }
        int i = ioff + cI;
        int j = joff + cJ;
        if (i >= 0 && i < ROWS && j >= 0 && j < COLS) {
          if (chessboard[i][j].val.indexOf(opponent) != -1 || chessboard[i][j].val == "-") {
            validMoves.add(chessboard[i][j]);
          }
        } 
      } 
    } 
    return validMoves;
  } 
} 

class Cell {
  String val;
  int col;
  PImage img;
  int i;
  int j;
  float w;
  int count;
  Cell(String _val, int _col, int _i, int _j, float _w) {
    val = _val;
    col = _col;
    img = null;
    i = _i;
    j = _j;
    w = _w;
    count = 0;
  } 

  void setVal(String _val) {
    val = _val;
    img = loadImage(val+".png");
  } 
  void show() {
    fill(col * 150, 50, 0);
    noStroke();
    rect(j * w, i * w, w, w);
    if (img != null) {
      image(img, j * w, i * w, w, w);
    }
  }
  void highlight() {
    fill(255, 100);
    strokeWeight(6);
    stroke(255);
    rect(j * w, i * w, w, w);
  }
  void highlight(color col) {
    fill(col, 50);
    strokeWeight(6);
    stroke(col);
    rect(j * w, i * w, w, w);
  }
} 
