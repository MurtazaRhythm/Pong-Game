//Murtaza Rhythm
// March 24,2024
// Pong game with Menu Screen

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim myMinim;
AudioPlayer overButton1, overButton2, overButton3, overButton4, overButton5, // I had to use 5 different variables for the hovering sound effect for some reason the sound wasn't working when reused the same variable.
  mouseClick1, bgMusic, hit, gameOver, ding;

//fonts, colors, images
color border = #CBA0E3;
color button = #630bbd;
PFont font, title;
int menu = 0;
int score = 0;

//Physics of the ball
class PVector {
  float x;
  float y;
  float w;
  float h;

  PVector(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
  }
  void add(PVector v) {
    x = x + v.x;
    y = y + v.y;
    w = w + v.w;
    h = h + v.h;
  }
}
PVector ball;
PVector vel;

void setup()
{
  //sounds
  myMinim =new Minim(this);
  overButton1 = myMinim.loadFile("ButtonToggle.mp3");
  overButton2 = myMinim.loadFile("ButtonToggle.mp3");
  overButton3 =  myMinim.loadFile("ButtonToggle.mp3");
  overButton4 = myMinim.loadFile("ButtonToggle.mp3");
  overButton5 = myMinim.loadFile("ButtonToggle.mp3");
  mouseClick1 = myMinim.loadFile("mouseClick.mp3");
  bgMusic = myMinim.loadFile("bg.mp3");
  hit = myMinim.loadFile("hit.wav");
  gameOver = myMinim.loadFile("gameOver.mp3");
  ding = myMinim.loadFile("Ding.mp3");

  //fonts
  font = createFont("39335_UniversCondensed.ttf", 50);
  title = createFont("CYBERG__.TTF", 50);

  //etc
  strokeWeight(6);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  size(800, 720);

  //bouncing ball
  ball = new PVector(100, 100, 20, 20);
  vel = new PVector(5, 5, 0, 0);
}

void draw() {
  switch(menu)
  {
  case 0:
    {
      bgMusic.loop();
      menu();
    }
    break;
  case 1:
    {
      play();
    }
    break;
  case 2:
    {
      endGame();
    }
    break;
  }
}

//Physics for ball
void ball() {
  ellipse(ball.x, ball.y, ball.w, ball.h);
  ball.add(vel);
  if ( ball.y < 0) {
    vel.y = - vel.y;
  }
  if (ball.x < 0|| ball.x > width) {
    vel.x = - vel.x;
  }
  if ( ball.x >= mouseX - 50 && ball.x <= mouseX+50 && ball.y == height -30) {
    hit.play();
    hit.rewind();
    vel.y = -vel.y * 1.05;
    score += 1;
    if (score % 10 == 0) {
      ding.play();
      ding.rewind();
    }
  }
  if (ball.y > height)
  {
    menu = 2;
  }
}

//bouncing ball for menu screen
void ballMenu() {

  ellipse(ball.x, ball.y, ball.w, ball.h);
  ball.add(vel);
  if ( ball.y < 0 || ball.y > height) {
    vel.y = - vel.y;
    hit.play();
    hit.rewind();
  }
  if (ball.x < 0|| ball.x > width) {
    vel.x = - vel.x;
    hit.play();
    hit.rewind();
  }
}

//menu screen
void menu() {
  background(100);
  title();
  buttonPlay();
  buttonExit();
  ballMenu();
}

//playing screen
void play()
{
  background(200);
  fill(0);
  noStroke();
  rect(mouseX, height - 20, 100, 15);
  text(score, width/2, height/2 - 100);
  ball();
  gameOver.rewind();
}

//Endgame Screen
void endGame() {
  background(100);
  textSize(40);
  text("GAME OVER!", width/2, 100);
  text("Score:" + " " + score, width/2, 150);
  gameOver.play();
  buttonPlay();
  buttonExit();
  buttonMenu();
}

//Reset the data to play again
void reset() {
  ball = new PVector(100, 100, 20, 20);
  vel = new PVector(5, 5, 0, 0);
  score = 0;
}

//PLAY button
void buttonPlay() {
  if (isMouseOver(width/2, height/2 - 100, 200, 70)) { // sees if the mouse is over given parameters
    stroke(button); // changes color of the button with the color of the border
    fill(border); //changes color of the border with the color of the button
    rect(width/2, height/2 -100, 200, 70, 5); //positioning the button
    fill(0); //text color
    textFont(font); //applying font
    text("Play", width/2, height/2 - 100);
    if (mousePressed) // checking if mouse is pressed while hovering above the button
    {
      stroke(button); // keeping the same color scheme as the above mentioned one
      fill(border);
      rect(width/2, height/2 -100, 250, 120, 5); // increasing the width and height of the button to show button is being pressed
      fill(0);
      textFont(font);
      text("Play", width/2, height/2 - 100);
      reset();
      menu = 1;
      mouseClick1.play(); //sound effects
      mouseClick1.rewind();
    }
  } else {
    // this is how the button looks in menu screen
    fill(button);
    stroke(border);
    rect(width/2, height/2 - 100, 200, 70, 5);
    fill(255);
    textFont(font);
    text("Play", width/2, height/2 - 100);
    overButton1.play();
    overButton1.rewind();
  }
}

// EXIT button
void buttonExit() {
  if (isMouseOver(width/2, height/2, 200, 70)) {
    stroke(button);
    fill(border);
    rect(width/2, height/2, 200, 70, 5);
    fill(0);
    textFont(font);
    text("Exit", width/2, height/2 );
    fill(255);
    if (mousePressed)
    {
      stroke(button);
      fill(border);
      rect(width/2, height/2, 250, 120, 5);
      fill(0);
      textFont(font);
      text("Exit", width/2, height/2 );
      fill(255);
      mouseClick1.play();
      mouseClick1.rewind();
      exit();
    }
  } else {
    fill(button);
    stroke(border);
    rect(width/2, height/2, 200, 70, 5);
    fill(255);
    textFont(font);
    text("Exit", width/2, height/2);
    overButton4.play();
    overButton4.rewind();
  }
}

//To return back to menu
void buttonMenu() {
  if (isMouseOver(width/2, height/2 +100, 200, 70)) {
    stroke(button);
    fill(border);
    rect(width/2, height/2 +100, 200, 70, 5);
    fill(0);
    textFont(font);
    text("Menu", width/2, height/2 +100);
    fill(255);
    if (mousePressed)
    {
      stroke(button);
      fill(border);
      rect(width/2, height/2 +100, 250, 120, 5);
      fill(0);
      textFont(font);
      text("Menu", width/2, height/2 +100);
      mouseClick1.play();
      mouseClick1.rewind();
      menu = 0;
      reset();
    }
  } else {
    fill(button);
    stroke(border);
    rect(width/2, height/2 +100, 200, 70, 5);
    fill(255);
    textFont(font);
    text("Menu", width/2, height/2 +100 );
    overButton2.play();
    overButton2.rewind();
  }
}

//TITLE
void title() {
  textFont(title);
  text("Pong", width/2, height/2 -250);
}

// Checks if mouse is over given parameters
boolean isMouseOver(int x, int y, int w, int h) {
  if (mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2) {
    return  true;
  }
  return false;
}
