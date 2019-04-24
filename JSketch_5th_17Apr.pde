int marginY = 50;

int downY = 1;

float x, y;

boolean have_defeated_enemy = false;

void setup() {
  
  //Drawing the background
  size(600, 600);
  //background(32, 41, 49) //put this in to leave a trail
  
  x= 0 - 90;
  y= random(600 - 90);
  
  frameRate(20);
  
  //might need to add coin toss to decide whether sideways
}

void draw() {
  //the sky
  background(32, 41, 49);
  
  //The Ground
  fill(49, 53, 48);
  rect(0, height/1.1, 600, 300);
  
  //The Plant??
  fill(95, 106, 117, 230);
  rect(width/2.1, height/1.2, 50, 50);
  
  fill(random(255));
  //moon
  ellipse(50, 50, 70, 70);
  
  fill(255);
  ellipse(50, 50, 50, 50);
  
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
            fill(151, 161, 156);
            rect(x, y, 50, 50);
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
}
