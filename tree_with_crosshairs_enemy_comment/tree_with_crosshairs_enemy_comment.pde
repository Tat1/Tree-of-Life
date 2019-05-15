/* We use the PGraphics instance for the imagery which builds over time (so we never want to
   call background() on it.) The main graphics canvas is redrawn each time, so that we can
   get an animated cross-hairs cursor. Whenever we clear the main canvas, we redraw the
   accumulated PGraphics back onto it.
  
   Based on: https://processing.org/examples/creategraphics.html
 */

//Lets it be recognised in setup and draw

//Pgraphics
PGraphics pg;

//Image
PImage img;

//the x value
int j, y;

float x;

boolean have_defeated_enemy = false;

boolean going_right = true;

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
  //include random of x and y minus the size of the enemy like x= random(400 - 50)
  
  //Allows the enemy to move in its y axis
  y = int(random(600-50));
  
  //allowing it to come in sideways
  
  //coin toss to decide whether left or right
  if (random(100) > 50){
  going_right = false;
  }
  else{
  going_right = true;
  }
  

}

void draw() {
  int mx = j;    //x/j for the enemy
  int my = y; //y for the enemy
  
  int pixelPos;
  int pixelValue; //  Packed RGB
  
  
  //Draws the tree into the pGraphic, calls it from void tree
  pg.beginDraw();
  tree();
  pg.endDraw();
  
  background(0); //always clears the canvas to black
  image(pg, 0, 0); //always redraw the PGraphic
  
  /*
  //if defeated enemy is false fill black, 
  //else if my is greater than height or mx is greater than width, draw red
  //else don't do anything
  if (have_defeated_enemy){//has main priority over the elif
    //fill(0);
  } else if (my > height || mx > width){
    fill(171, 40, 49); //red
  } else {
    //pass
  }
  */
  
  //If enemy is defeated which is false or the mouse is within the enemy make defeated enemy true and fill black
  //else if defeat remains false draw enemy and move enemy across the screen
  if ((have_defeated_enemy) || (mouseX > mx && mouseX < mx + 50 && mouseY > my && mouseY < my + 50)) {
  (have_defeated_enemy) = true;
  fill(0);
  }
  else{
    //img, x , y, w, h
    image(img, j, my, 70, 70);//Draw img, j/mx , my/500, width, height)
    j = j + 1; // Allows it to move along
    }
  
    
  if((have_defeated_enemy)){
    if (going_right){
      x = x - 1;
    }else{
      x = x + 1;
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
