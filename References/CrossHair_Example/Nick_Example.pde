/* We use the PGraphics instance for the imagery which builds over time (so we never want to
   call background() on it.) The main graphics canvas is redrawn each time, so that we can
   get an animated cross-hairs cursor. Whenever we clear the main canvas, we redraw the
   accumulated PGraphics back onto it.
  
   Based on: https://processing.org/examples/creategraphics.html
 */

PGraphics pg;

void setup() {
  size(400, 400);
  pg = createGraphics(400, 400);      // PGraphics is same size (and location) as main canvas.
}

void draw() {
  int mx = mouseX;
  int my = mouseY;
  
  int pixelPos;
  int pixelValue;        //  Packed RGB (I'm guessing).
  
  
  if (frameCount % 50 == 0) {          // In the PGraphics, periodically draw an additional white dot.
    pg.beginDraw();
    pg.fill(255);
    pg.ellipse(random(width), random(height), 10, 10);
    pg.endDraw();
  }
  
  pg.beginDraw();
  pg.loadPixels();
  pixelPos = my * width + mx;
  pixelValue = pg.pixels[pixelPos];    // Find the colour value at the mouseX/mouseY position.
  pg.endDraw();
  
  background(0);                       // Always clear canvas to black
  image(pg, 0, 0);                     // Always redraw the PGraphics
  
  if (pixelValue != 0) {               // Is the examined PGraphics pixel non-black? If so, yellow crosshairs.
    stroke(255, 255, 0);
  } else {
    stroke(100, 100, 100);
  }

  // (Re)draw crosshairs.
  noFill();
  rect(mx, 0, 0, height);
  rect(0, my, width, 0);
}
