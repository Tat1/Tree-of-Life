int marginY = 50;

int downY = 1;

float x, y;

boolean have_defeated_enemy = false;

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
    if (diameter>0.5) {
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
  //Drawing the background
  size(600, 600);
  
  x= 0 - 90;
  y= random(600 - 90);
  
  frameRate(20);
  
  background(0);
  ellipseMode(CENTER);
  fill(255);
  noStroke();
  smooth();
  paths = new pathfinder[1];
  paths[0] = new pathfinder();
}

void draw() {
  //The Plant??
  for (int i=0;i<paths.length;i++) {
    PVector loc = paths[i].location;
    float diam = paths[i].diameter;
    fill(255);
    ellipse(loc.x, loc.y, diam, diam);
    paths[i].update();
  }
  
  if (have_defeated_enemy){
    fill(32, 41, 49);
  } else if (y > height || x > width/2){
    background(171, 40, 49); //red
  } else {
    //pass
  }
    
  
  if ((have_defeated_enemy) || (mouseX > x && mouseX < x + 50 && mouseY > y && mouseY < y + 50)) {
  (have_defeated_enemy) = true;
  fill(32, 41, 49);
  }
        
    else{
        for (int i=0; i<(downY); i++);
            //x,y,w,h
            fill(230, 34, 43);
            ellipse(x, y, 50, 50);
            //rect(x, height / downY + marginY, 50, 50);
            x = x + 1;
            //rect(20, i * height / downY + marginY, 20, height/ downY - marginY * 2)
    }
  
}

void keyPressed(){
    print ("key Pressed");
    // reset the game
    x = 0;
    y = random(600 - 90);
    (have_defeated_enemy) = false;
    
    background(0);
    paths = new pathfinder[1];
    paths[0] = new pathfinder();
}
