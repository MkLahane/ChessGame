import java.util.*;
import processing.sound.*;
String backgroundSoundName = "BackgroundScoreNicaragua.mp3";
SoundFile backgroundSound;
int ROWS = 8;
int COLS = 8;
Game game;
PImage img;
Cell currentCell;
boolean gameOver;
boolean selected = false;
String currentPlayer = "black";
ArrayList<Cell> validMoves;
void setup() {
  size(700, 700);
  //fullScreen();
  gameOver = false;
  game = new Game();
  validMoves = new ArrayList<Cell>();
  img = loadImage("blackpawn.png");
  String backgroundSoundPath = sketchPath(backgroundSoundName);
  backgroundSound = new SoundFile(this, backgroundSoundPath);
  backgroundSound.play();
} 

void draw() {
  background(255);
  if (frameCount % (209 * 60) == 0) {
    backgroundSound.stop();
    backgroundSound.play();
  } 
  game.render();
  if (selected) {
    currentCell.highlight(color(255));
    validMoves = game.displayValidMoves(currentCell.i, currentCell.j);
    for (Cell validMove : validMoves) {
      validMove.highlight(color(0, 200, 0));
    } 
  }
  if (gameOver) {
    noLoop();
  } 
} 

void move(Cell movedTo) {
  if (movedTo.val.indexOf("king") != -1) {
    gameOver = true;
  } 
  movedTo.setVal(currentCell.val);
  if (movedTo.val.indexOf("pawn") != -1) {
    movedTo.count++;
  } 
  currentCell.val = "-";
  currentCell.img = null;
  if (currentPlayer == "white") {
    currentPlayer = "black";
  } else {
    currentPlayer = "white";
  }
} 

void mousePressed() {
  if (selected) {
    Cell temp = game.check(mouseX, mouseY); 
    if (validMoves.contains(temp)) {
      move(temp);
      selected = false;
      currentCell = null;
    } 
    if (temp == null) {
      return;
    } 
    if ((currentPlayer == "black" && temp.val.indexOf("black") != -1) ||
        (currentPlayer == "white" && temp.val.indexOf("white") != -1)) {
      currentCell = temp;
    } 
  } else {
    currentCell = game.check(mouseX, mouseY);
    if (currentCell == null) {
      return;
    } 
    if ((currentPlayer == "white" && currentCell.val.indexOf("white") != -1) ||
      (currentPlayer == "black" && currentCell.val.indexOf("black") != -1)) {
      selected = true;
    } else {
      selected = false;
      currentCell = null;
    }
  } 
  //selected = !selected;
  //if (selected) {
  //  currentCell = game.check(mouseX, mouseY);
  //  if (currentCell.val == "-") {
  //    selected = false;
  //    currentCell = null;
  //  } 
  //} else {
  //  currentCell = null;
  //}
}
