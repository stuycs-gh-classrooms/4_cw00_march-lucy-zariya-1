
int DOT_RESOLUTION = 20;
String PICFILE = "us-temps.png";

PImage art;
boolean showDots;
int resolution;

float threshold = 100;

/*================================
 You should leave setup alone, with the exception
 of changing the size if not using the provided boats.jpg
 imgage.
 ================================*/
void setup() {
  size(770, 550);
  showDots = false;
  resolution = DOT_RESOLUTION;
  art = loadImage(PICFILE);
  art.loadPixels();
}//setup

/*================================
 You should leave draw alone.
 ================================*/
void draw() {
  background(255);
  image(art, 0, 0);
  if (showDots) {
    dots(art, resolution);
  }
}//draw


/*================================
 keyPressed
 `r`: reset back to the original image.
 `g`: grayScale the image
 `e`: perform edge detection on the image (this will be added tomorrow)
 ================================*/
void keyPressed() {
  if (key == 'h') {
    art = highlightRed(art, threshold);
  } else if (key == 'd') {
    showDots = !showDots;
  }//edge detect
  else if (key == 'r') {
    art = loadImage(PICFILE);
    art.loadPixels();
  }//reset image
}//keyPressed


/*================================
 Returns the grayScale value of a color
 ================================*/
int calculateGray(color c) {
  int g = int((red(c) + green(c) + blue(c)))/3;
  return g;
}//calculateGray
/*================================
 Returns the correct pixel index for img based on the provided x and y values.
 ================================*/
int getIndexFromXY(int x, int y, PImage img) {
  return y * img.width + x;
}//getIndexFromXY

color[] getNeighborRed(PImage img, int x, int y) {
  color[] neighborhood = new color[4];

  if (x>0 && x < img.width && y>=0 && y<img.height) {
    neighborhood[0] = int(red(img.pixels[getIndexFromXY(x-1, y, img)]));
  } else {
    neighborhood[0] = 0;
  }
  if (x>=0 && x < img.width && y>0 && y<img.height) {
    neighborhood[1] = int(red(img.pixels[getIndexFromXY(x, y-1, img)]));
  } else {
    neighborhood[1] = 0;
  }
  if (x>=0 && x < img.width-1 && y>=0 && y<img.height) {
    neighborhood[2] = int(red(img.pixels[getIndexFromXY(x+1, y, img)]));
  } else {
    neighborhood[2] = 0;
  }
  if (x>=0 && x < img.width && y>=0 && y<img.height-1) {
    neighborhood[3] = int(red(img.pixels[getIndexFromXY(x, y+1, img)]));
  } else {
    neighborhood[3] = 0;
  }

  return neighborhood;
}//getNeighborColors

float getDifference(color[] colors, color c) {
  int sum = 0;
  int numColors = 0;
  for (int i = 0; i < colors.length; i++) {
    if (colors[i] != 0) {
      sum += (calculateGray (colors[i]) -calculateGray (c));
      numColors ++;
    }
  }
  if (numColors == 0) {
    numColors = 1;
  }
  float difference = abs (sum/numColors);

  return difference;
}//getDifference

PImage highlightRed(PImage img, float t) {
  PImage newImg = new PImage(img.width, img.height);

  for (int p=0; p<img.pixels.length; p++) {
    color[] neighbors = getNeighborRed(img, p%img.width, p/img.height);
    float diff = getDifference(neighbors, img.pixels[p]);
    if (diff > t) {
      newImg.pixels[p] = color(255);
    } else {
      newImg.pixels[p] = color(0);
    }
  }
  return newImg;
}//higlightRed



void dots(PImage img, int resolution) {
    for (int p=0; p<img.pixels.length; p++) {
      if (p%resolution ==0) {
            circle(p%img.width, p/img.width, resolution/2); 
      }
    }
}//dots
