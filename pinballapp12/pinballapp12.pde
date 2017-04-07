import org.jbox2d.util.nonconvex.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.testbed.*;
import org.jbox2d.collision.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.p5.*;
import org.jbox2d.dynamics.*;

Maxim maxim;
AudioPlayer guardSound, startSound, bumperSound, flipperSound, slingshotSound, wallSound;

Physics physics;
Body ball, rflipper, lflipper, rslingshot, lslingshot, b1, b2, b3, b4, b5, wall;
CollisionDetector detector; 

PImage ballImg, rflipImg, lflipImg, rslingImg, lslingImg, b1Img, b2Img, b3Img, b4Img, b5Img, bgImg, frameImg, inicioImg;

int lfliprot = -25, lup = 0, rfliprot = 25, rup = 0;
int score = 0;
Vec2 impulse;

void setup() 
{
  size(320,480);
  frameRate(60);
  imageMode(CENTER);

  
inicioImg = loadImage("inicio.jpg");
  
  ballImg = loadImage("ball.png");
  ballImg.resize(20,20);
  
  rflipImg = loadImage("rflipper.png");
  rflipImg.resize(100,40);
  lflipImg = loadImage("lflipper.png");
  lflipImg.resize(100,40);
  
  rslingImg = loadImage("rsling.png");
  rslingImg.resize(50,100);
  lslingImg = loadImage("lsling.png");
  lslingImg.resize(50,100);
  
  b1Img = loadImage("bumper.png");
  b1Img.resize(25,25);
  b2Img = loadImage("bumper.png");
  b2Img.resize(25,25);
  b3Img = loadImage("bumper.png");
  b3Img.resize(25,25);
  b4Img = loadImage("bumper.png");
  b4Img.resize(25,25);
  b5Img = loadImage("bumper.png");
  b5Img.resize(25,25);
  
  bgImg = loadImage("bg.jpg");
  frameImg = loadImage("frame.png");
  frameImg.resize(width, height);

  maxim = new Maxim(this);
  guardSound = maxim.loadFile("guard.wav");
 guardSound.play();
}

void draw() 
{ 
 image(inicioImg,  width/2, height/2, width, height);
 
     //if (keyPressed==true){
 if(key == 'b' || key == 'B'){
  dibujo();
 }
 if(key == 'q' || key == 'Q'){
  dibujo();
 }
 if(key == 'p' || key == 'P'){
  dibujo();
 }

}

void keyPressed()
{
  if(key == 'b' || key == 'B'){
    juego();
    //dibujo();
  }
  
  if(key == 'q' || key == 'Q')
  {
    lup = 1;
    flipperSound.cue(0);
    flipperSound.play();
  }
  if(key == 'p' || key == 'P')
  {
    rup = 1;
    flipperSound.cue(0);
    flipperSound.play();
  }
}

void myCustomRenderer(World world) 
{ 
  Vec2 ballpos = physics.worldToScreen(ball.getWorldCenter());
  if(ballpos.y > 465)
  {
    textAlign(CENTER);
    textSize(20);
    fill(#fff000);
    text("GAME OVER", width/2, height/2);
  }
  pushMatrix();
  translate(ballpos.x, ballpos.y);
  image(ballImg, 0, 0, ballImg.width, ballImg.height);
  popMatrix();
  
  pushMatrix();
  translate(115, 425);
  rotate(-radians(lfliprot));
  if(lup == 1 && lfliprot < 50)
    lfliprot += 5;
  else if(lfliprot == 50)
    lup = 0;
  if(lup == 0 && lfliprot > -25)
    lfliprot -= 5;
  image(lflipImg, 0, 0, lflipImg.width, lflipImg.height);
  popMatrix();
  lflipper.setAngle(radians(lfliprot));
  
  pushMatrix();
  translate(205, 425);
  rotate(-radians(rfliprot));
  if(rup == 1 && rfliprot > -50)
    rfliprot -= 5;
  else if(rfliprot == -50)
    rup = 0;
  if(rup == 0 && rfliprot < 25)
    rfliprot += 5;
  image(rflipImg, 0, 0, rflipImg.width, rflipImg.height);
  popMatrix();
  rflipper.setAngle(radians(rfliprot));
}

void collision(Body bod1, Body bod2, float imp)
{
  if(bod1 == b1 || bod1 == b2 || bod1 == b3 || bod1 == b4 || bod1 == b5 || bod2 == b1 || bod2 == b2 || bod2 == b3 || bod2 == b4 || bod2 == b5)
  {
    impulse.set(ball.getWorldCenter());
    impulse = impulse.mul(-2);
    ball.applyImpulse(impulse, ball.getWorldCenter());
    if(bod1 == b4 || bod2 == b4 || bod1 == b5 || bod2 == b5)
      score += 1000;
    else
      score += 500;
    bumperSound.cue(0);
    bumperSound.play();
  }
  else if(bod1 == lflipper || bod2 == lflipper)
  {
    if(lfliprot > -5)
    {
      impulse.set(ball.getWorldCenter());
      impulse = impulse.mul(-5);
      ball.applyImpulse(impulse, ball.getWorldCenter());
    }
    score += 250;
  }
  else if(bod1 == rflipper || bod2 == rflipper)
  {
    if(rfliprot < 5)
    {
      impulse.set(ball.getWorldCenter());
      impulse = impulse.mul(-10);
      ball.applyImpulse(impulse, ball.getWorldCenter());
    }
    score += 250;
  }
  else if(bod1 == wall || bod2 == wall)
  {
    score += 100;
    wallSound.cue(0);
    wallSound.play();
  }
  else if(bod1 == lslingshot || bod1 == rslingshot || bod2 == lslingshot || bod2 == rslingshot)
  {
    impulse.set(ball.getWorldCenter());
    impulse = impulse.mul(-1);
    ball.applyImpulse(impulse, ball.getWorldCenter());
    score += 750;
    slingshotSound.cue(0);
    slingshotSound.play();
  }
}

void dibujo(){
    image(bgImg,  width/2, height/2, width, height);
  image(frameImg, width/2, height/2, frameImg.width, frameImg.height);
  image(b1Img, 135, 155, b1Img.width, b1Img.height);
  image(b2Img, 185, 155, b2Img.width, b2Img.height);
  image(b3Img, 160, 205, b3Img.width, b3Img.height);
  image(b4Img, 250, 85, b4Img.width, b4Img.height);
  image(b5Img, 70, 85, b5Img.width, b5Img.height);
  image(lslingImg, 80, 350, lslingImg.width, lslingImg.height);
  image(rslingImg, 240, 350, rslingImg.width, rslingImg.height);
  
  fill(255);
  text("Score:    " + score, 10, 20);
}


void juego(){
    physics = new Physics(this, width, height, 0, -20, width*2, height*2, width, height, 100);
  physics.setCustomRenderingMethod(this, "myCustomRenderer");
 
  physics.setDensity(10.0);
  ball = physics.createCircle(170, 150, 7);
  
  physics.setDensity(0.0);
  lflipper = physics.createRect(75,420,155,430);
  rflipper = physics.createRect(245, 420, 165, 430);
  b1 = physics.createCircle(135, 155, 10);
  b2 = physics.createCircle(185, 155, 10);
  b3 = physics.createCircle(160, 205, 10);
  b4 = physics.createCircle(250, 85, 10);
  b5 = physics.createCircle(70, 85, 10);
  lslingshot = physics.createPolygon(113, 395, 65, 280, 65, 368);
  rslingshot = physics.createPolygon(255, 368, 255, 280, 207, 395);
  wall = physics.createRect(30, 45, 43, 390);
  wall = physics.createRect(277, 45, 290, 390);
  wall = physics.createRect(30, 40, 290, 55);
  wall = physics.createPolygon(30, 390, 115, 430, 120, 415, 45, 380);
  wall = physics.createPolygon(275, 380, 200, 415, 205, 430, 290, 390);  

  detector = new CollisionDetector (physics, this);
  impulse = new Vec2();
 
 maxim = new Maxim(this);
 
  startSound = maxim.loadFile("start.wav");
  bumperSound = maxim.loadFile("bumper.wav");
  flipperSound = maxim.loadFile("flipper.wav");
  slingshotSound = maxim.loadFile("slingshot.wav");
  wallSound = maxim.loadFile("wall.wav");
  
  startSound.setLooping(false);
  bumperSound.setLooping(false);
  flipperSound.setLooping(false);
  slingshotSound.setLooping(false);
  wallSound.setLooping(false);
  startSound.play();

  
}
