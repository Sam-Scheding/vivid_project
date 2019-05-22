/*
  Creative development: Use randomness, and take inspiration from any of the above exercises, 
  to create a visual or sonic generative artwork following the principle of “simple-but-effective” 
  (e.g., don’t write 10000s of lines of code, but find simple and beautiful ways to generate form).

  --------------------------------------------------------------------------------------------
  
  This is my attempt at the Creative Development. I generate Perlin noise
  and leverage it's properties of self similarity to 'fly' over a landscape.
  It generates infinitely, going up to x = MAX_INT, and then wraps around to MIN_INT

  I then combine the perlin noise with a sine wave to give it a psychelic oily look.
  
  I like the look of this, but unfortunately, I couldn't optimise it as much as I'd like,
  so its pretty slow.
*/

import org.openkinect.processing.*;

Kinect2 kinect2;

PImage depthImg;

int w, h;

float offset = 0;


void setup(){
  
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();  
  size(512, 424);
  depthImg = new PImage(kinect2.depthWidth, kinect2.depthHeight);
}

void draw(){
  int[] rawDepth = kinect2.getRawDepth();
  int w = 512; h = 424;
  background(0);
  offset += 0.2;
  for(int x = 0; x < w; x++){
    for(int y = 0; y < h; y++){
      int idx = y*w + x;
      float depth = rawDepth[idx];
      if(depth > 1500 || depth < 100){ depthImg.pixels[idx] = 0; continue; }
      depth = map(depth, 0, 2048, 0, 1);
      float colourScale = 2 * sin(y*depth + offset);
      PVector vec = new PVector(map(depth, 0, 1, 0, 50), map(depth*colourScale, 0, 1, 0, 250), map(depth*colourScale, 0, 1, 0, 100));
      color c = color(vec.x, vec.y, vec.z);
      depthImg.pixels[idx] = c;
    }
  }
  text("jhfhf", 10, 10);
  depthImg.updatePixels();
  image(depthImg, 0, 0);
}
