//Lets it be recognised in setup and draw

//Pgraphics
PGraphics pg;

//Image
PImage img;
PImage img2;
PImage imgnew;

//the x value

int mx, my;

float x;

boolean have_defeated_enemy = false;

boolean going_right;


int rad = 70;     

int xdirection = 1;
int ydirection = 1;

int have_hit =0;

//The tree, sets up the main branch and randomises location
class pathfinder {
  PVector location;
  PVector velocity;  
  float diameter;
  pathfinder() {
    location = new PVector(width/2, height);
    velocity = new PVector(0, -1);
    diameter = 32;
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
  
  //Drawing the screen
  size(600, 600);
  
  //Creating the size of the PGraphic of the tree, making it the same size and location as the screen
  pg = createGraphics(600, 600);
  
  //slows down the animation
  frameRate(20);
  
  // need to put in millis
  img = loadImage("title_page.png");
  img = loadImage("end_page.png");
  
  //Setting up the Tree path and extra path
  ellipseMode(CENTER);
  fill(255);
  noStroke();
  smooth();
  paths = new pathfinder[1];
  paths[0] = new pathfinder();
  
  //Loading the enemy in setup
  img = loadImage("Enemy_2.png");
  img2 = loadImage("Enemy_2.png");
  imgnew = loadImage("New_Enemy_1.png");
  //include random of x and y minus the size of the enemy like x= random(400 - 50)
  
  //Allows the enemy to move in its y axis
  //y = int(random(600-50));

  
  
  //coin toss to decide whether left or right
  if (random(100) > 50){
  going_right = true;
  }
  else{
  going_right = false;
  }
 }

void draw() {
  
  int pixelPos;
  int pixelValue; //  Packed RGB
  
  
  //Draws the tree into the pGraphic, calls it from void tree
  pg.beginDraw();
  tree();
  pg.endDraw();
  
  background(0); //always clears the canvas to black
  image(pg, 0, 0); //always redraw the PGraphic
  
  
  //If enemy is defeated which is false or the mouse is within the enemy make defeated enemy true and fill black
  //else if defeat remains false draw enemy and move enemy across the screen
  
  if  (mouseX > mx && mouseX < mx + 50 && mouseY > my && mouseY < my + 50) {
  if(random(100) > 50){
  mx= 0;
  xdirection = 1;
  }else{
    mx= (width-rad);
    xdirection = -1; 
  }
  have_hit = 0;
  my=(int)random(height-rad);
  }
  else{
    if (mx > width-rad || mx < 0) {
      xdirection *= -1;
      have_hit = 0; 
    }
    if (have_hit == 1){
      image(imgnew, mx, my, 70, 70);
      mx = mx + xdirection;
    }else{
      image(img, mx, my, 70, 70);
      mx = mx + xdirection;
    }
  }
  
  
  pg.beginDraw();
  pg.loadPixels();
  pixelPos = my * width + mx;          //y direction times width + x direction
  pixelValue = pg.pixels[pixelPos];    // Find the colour value at enemy position.
  pg.endDraw();
  
  //Can comment out later, showing where enemy hits tree
  if (pixelValue != 0) {               // Is the examined PGraphics pixel non-black? If so, yellow crosshairs.
    stroke(255, 255, 0);// yellow
    (have_hit) = 1;
  } else {
    stroke(100, 100, 100);//Line colour grey before it intersects
  }
  
  // (Re)draw crosshairs.
  noFill();
  rect(mx, 0, 0, height); //Draws the cross hair of x
  rect(0, my, width, 0);  //Draws the cross hair of y
  }
  
void tree(){
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

//For the restart
void keyPressed(){
    print ("key Pressed");
    background(0);
    paths = new pathfinder[1];
    paths[0] = new pathfinder();
}
