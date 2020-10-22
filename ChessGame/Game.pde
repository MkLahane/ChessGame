class Game {
  Board board;
  Game() {
    board = new Board();
  } 
  void render() {
    board.showBoard();
  } 
  Cell check(float mX, float mY) {
    return board.check(mX, mY);
  } 
  ArrayList<Cell> displayValidMoves(int currentCellI, int currentCellJ) {
    return board.displayValidMoves(currentCellI, currentCellJ);
  }
} 
