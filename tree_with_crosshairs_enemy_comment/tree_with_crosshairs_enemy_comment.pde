import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// The kinect stuff is happening in another class
KinectTracker tracker;
Kinect kinect;

//Lets it be recognised in setup and draw

//Pgraphics
PGraphics pg;

//Image
PImage img;
PImage imgnew;
PImage[] imgw = new PImage[9];
PImage[] imgb = new PImage[9];
PImage[] imgg = new PImage[9];

//the x, y value
int mx, my;

boolean have_defeated_enemy = false;

boolean going_right;


int rad = 70;     

float xspeed = 1;  // Speed of the enemy

int xdirection = 1;
int ydirection = 1;

int have_hit = 0;

int total_hits = 0;


//The tree, sets up the main branch and randomises location
class pathfinder {
  PVector location;
  PVector velocity;  
  float diameter;
  pathfinder() {
    location = new PVector(width/2, height);
    velocity = new PVector(0, -1);
    diameter = 40;
  }
  pathfinder(pathfinder parent) {
    location = parent.location.get();
    velocity = parent.velocity.get();
    float area = PI*sq(parent.diameter/2);
    float newDiam = sqrt(area/2/PI)*2;
    diameter = newDiam;
    parent.diameter = newDiam;
  }
  void update() {
    if (diameter>0.1) {
      location.add(velocity);
      PVector bump = new PVector(random(-1, 1), random(-1, 1));
      bump.mult(0.1);
      velocity.add(bump);
      velocity.normalize();
      if (random(0, 1)<0.02) {
        paths = (pathfinder[]) append(paths, new pathfinder(this));
      }
    }
  }
}
pathfinder[] paths;


void setup() {
  //Kinect
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  
  //Drawing the screen
  //size(640, 480);
  fullScreen();
  
  //Creating the size of the PGraphic of the tree, making it the same size and location as the screen
  pg = createGraphics(width, height);
  
  //slows down the animation
  frameRate(30);
  
  // need to put in millis
  //imgw = loadImage("whitetree.gif");
  //Start Screen
  imgw[0] = loadImage( "whitetree1.gif" );
  imgw[1] = loadImage( "whitetree2.gif" );
  imgw[2] = loadImage( "whitetree3.gif" );
  imgw[3] = loadImage( "whitetree4.gif" );
  imgw[4] = loadImage( "whitetree5.gif" );
  imgw[5] = loadImage( "whitetree6.gif" );
  imgw[6] = loadImage( "whitetree7.gif" );
  imgw[7] = loadImage( "whitetree8.gif" );
  imgw[8] = loadImage( "whitetree9.gif" );
  
  //imgb = loadImage("blacktree.gif");
  //Lose Screen
  imgb[0] = loadImage( "blacktree1.gif" );
  imgb[1] = loadImage( "blacktree2.gif" );
  imgb[2] = loadImage( "blacktree3.gif" );
  imgb[3] = loadImage( "blacktree4.gif" );
  imgb[4] = loadImage( "blacktree5.gif" );
  imgb[5] = loadImage( "blacktree6.gif" );
  imgb[6] = loadImage( "blacktree7.gif" );
  imgb[7] = loadImage( "blacktree8.gif" );
  imgb[8] = loadImage( "blacktree9.gif" );
  
  //imgg = loadImage("goldtree.gif");
  //Win Screen
  imgg[0] = loadImage( "goldtree1.gif" );
  imgg[1] = loadImage( "goldtree2.gif" );
  imgg[2] = loadImage( "goldtree3.gif" );
  imgg[3] = loadImage( "goldtree4.gif" );
  imgg[4] = loadImage( "goldtree5.gif" );
  imgg[5] = loadImage( "goldtree6.gif" );
  imgg[6] = loadImage( "goldtree7.gif" );
  imgg[7] = loadImage( "goldtree8.gif" );
  imgg[8] = loadImage( "goldtree9.gif" );
  
  //Setting up the Tree path and extra path
  ellipseMode(CENTER);
  fill(255);
  noStroke();
  smooth();
  paths = new pathfinder[1];
  paths[0] = new pathfinder();
  
  //Loading the enemy in setup
  img = loadImage("Enemy_2.png");
  imgnew = loadImage("New_Enemy_1.png");
  
 }

void gameIsStillRunning(){
  int pixelPos;
  int pixelValue; //  Packed RGB
  
  //Kinect
  // Run the tracking analysis
  tracker.track();
  
  // Let's draw the raw location
  PVector v1 = tracker.getPos();
  
  //Draws the tree into the pGraphic, calls it from void tree
  pg.beginDraw();
  tree();
  pg.endDraw();
  
  background(0); //always clears the canvas to black
  image(pg, 0, 0); //always redraw the PGraphic
  
  fill(0, total_hits);
  rect(0, 0, width, height);
  
    //Tracker
  fill(255, 211, 2, 200);//Gold
  noStroke();
  //Use the V1.x as mouseX and V1.y as mouseY
  
  //makes the kinect tracking full screen
  float xscale = displayWidth/640.0;
  float yscale = displayHeight/480.0;
  
  ellipse(v1.x*xscale, v1.y*yscale, 20, 20);
  //println(v1.x);
  
  // Kinect Tracking hitting the enemy bounds
  //Setting up the coin toss for whcih side (right or left side of x) the enemy is going to come in through
  //Saves when its hit the tree once going in one direction then resets
  //Draws randomly in the y axis where the enemy will appear
  //xspeed increasing the enemies speed
  
  //if (mouseX > mx && mouseX < mx + 50 && mouseY > my && mouseY < my + 50) {
  if (v1.x*xscale > mx && v1.x*xscale < mx + 70 && v1.y*yscale > my && v1.y*yscale < my + 70) {
  if(random(100) > 50){
    mx=0;
  xdirection = 1;
  xspeed = xspeed + 1;
  //total_hits = 0;
  //println("xspeedleft",xspeed);
  }else{
    mx= (width-rad);
    xdirection = -1; 
    xspeed = xspeed + 1;
    //println("xspeedright", xspeed);
  }
  have_hit = 0;
  my=(int)random((height)-rad);
  }
  else{
    if (mx > width-rad || mx < 0) {
      xdirection *= -1;
      have_hit = 0;
    }
    if (have_hit == 1){
      image(imgnew, mx, my, 70, 70);
      mx = mx + ( (int)xspeed * xdirection );
    }else{
      image(img, mx, my, 70, 70);
      mx = mx + ( (int)xspeed * xdirection );
    }
  }
  //println(my, "my");
 // println(mx, "mx");
  pg.beginDraw();
  pg.loadPixels();
  pixelPos = my * width + mx;          //y direction times width + x direction
  pixelValue = pg.pixels[pixelPos];    // Find the colour value at enemy position.
  pg.endDraw();
  
  //Can comment out later, showing where enemy hits tree
  if ((pixelValue != 0) &&(have_hit==0)){               // Is the examined PGraphics pixel non-black?
    //stroke(255, 255, 0);// yellow
    (have_hit) = 1;
    total_hits = total_hits + 50;
  } else {
    //stroke(100, 100, 100);//Line colour grey before it intersects
  }
  
  /*
  // (Re)draw crosshairs.
  noFill();
  rect(mx, 0, 0, height); //Draws the cross hair of x
  rect(0, my, width, 0);  //Draws the cross hair of y
  */
}

//Drawing the gif for the different splash page screens
void draw() {
  if (millis()< 3500){
    image(imgw[frameCount%9], 0, 0, width, height);
  }
  else {
    if ((frameCount>8000)){
      image(imgg[frameCount%9], 0, 0, width, height);
    } else{
      if(total_hits > 255){ 
        image(imgb[frameCount%9], 0, 0, width, height);
      } else {
        gameIsStillRunning();
      }
    }
  }
}
  
void tree(){
  if(frameCount%10==0) {
    println(frameCount);
  for (int i=0;i<paths.length;i++) {
    //stroke(255);
    PVector loc = paths[i].location;
    float diam = paths[i].diameter;
    //pg.strokeWeight(1);
    //pg.stroke(255);
    pg.noStroke();
    pg.fill(255);
    pg.ellipse(loc.x, loc.y, diam, diam);
    paths[i].update();
  }
  }
}
