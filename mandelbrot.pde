// code is a variation of http://introcs.cs.princeton.edu/java/32class/Mandelbrot.java.html
// converted to processing example by dan royer (dan@marginallyclever.com) 2017-09-28
//---------------------------------------------------------------

PImage picture, results;  

int rainbowColors[] = {
  0x9400D3, // violet
  0x4B0082, // indigo
  0x0000FF, // blue
  0x00FF00, // green
  0xFFFF00, // yellow
  0xFF7F00, // orange
  0xff0000, // red
};

color rainbowTable[];
// camera coordinates
double xc   = 0;
double yc   = 0;
// camera zoom level
double zoom = 2.85;
double aspect;
boolean moved=false;
boolean paused=false;

void setup() {
  size(1024,768);
  
  // aspect ratio of image
  aspect = (double)height/(double)width;
  
  // image buffer for fractal calcuation
  picture = createImage(width,height, RGB);
  // image buffer for color cycling
  results = createImage(width,height, RGB);
  // fast cycling lookup table
  rainbowTable = new color[256];
  for(int i=0;i<256;++i) rainbowTable[i] = rainbow(i);
  
  xc=-0.7407339811325073;
  yc=-0.14992965757846832;
  zoom=0.030709465434152445;
  
  generateMandelbrot();
}


void generateMandelbrot() {
  long tStart = millis();
  int max = 256;   // maximum number of iterations
  
  double yc2=yc - (zoom/2.0)*aspect;
  double xc2=xc - (zoom/2.0);
  double x0,y0;
  int i,j;
  int gray;
  
  for (j = 0; j < height; j++) {
    y0 = yc2 + (zoom*j/(double)height) *aspect;
    for (i = 0; i < width; i++) {
      x0 = xc2 + (zoom*i/(double)width);
      Complex z0 = new Complex(x0, y0);
      gray = max - mand(z0, max);
      picture.set(i, j, color(gray,gray,gray));
    }
  }
  long tEnd=millis();
  println(tEnd-tStart+"ms");
}


void draw() {
  if(!paused) {
    cycleColors();
  }
  image(results,0,0);
  
  if(moved) {
    String coords = "x="+getMouseX()+"\ny="+getMouseY()+"\nz="+zoom;
    displayText(coords,0,15);
    stroke(255,255,255);
    point(width/2,height/2);
  }
  moved=false;
}

void cycleColors() {
  int frame=(int)((float)millis() * 0.02f);
  int red=0;
  int v;
  for(int y=0;y<height;++y) {
    for(int x=0;x<width;++x) {
      red = picture.pixels[y*width+x] & 0xff;
      v = rainbowTable[( (red+frame) & 0xff )];
      results.set(x,y,v);  // works
      //results.pixels[y*width+x] = v;  // doesn't work!?
    }
  }
}

void displayText(String arg0,int x,int y) {
  fill(0);
  text(arg0,x-1,y-1);
  text(arg0,x  ,y-1);
  text(arg0,x+1,y-1);
  text(arg0,x-1,y+1);
  text(arg0,x  ,y+1);
  text(arg0,x+1,y+1);
  fill(255,255,255);
  text(arg0,0,15);
}


double getMouseX() {
  float xc0=(float)xc - (float)zoom/2.0f;
  float xc1=(float)xc + (float)zoom/2.0f;
  
  return lerp(xc0,xc1,(float)((mouseX)/(float)(width)));
}

double getMouseY() {
  float yc0=(float)yc - (float)(zoom/2.0f)*(float)aspect;
  float yc1=(float)yc + (float)(zoom/2.0f)*(float)aspect;
  
  return lerp(yc0,yc1,(float)((mouseY)/(float)(height)));
}

void keyPressed() {
  if(key==' ') paused=!paused;
}

void mouseMoved() {
  moved=true;
}

void mouseClicked() {
  if(paused) return;
  
  zoom*=0.9;
  xc = getMouseX();
  yc = getMouseY();
  print("xc="+xc+"; xc="+yc+"; zoom="+zoom+";");
  generateMandelbrot();
}


// takes a value from 0...255
color rainbow(int arg0) {
  float f = (float)rainbowColors.length * (float)arg0 / 256.0f;
  int i = floor(f);
  int j = (i+1) % rainbowColors.length;
  float fraction = f-i;
  int ca = rainbowColors[i];
  int cb = rainbowColors[j];
  float r = lerp(   red(ca),   red(cb), fraction);
  float g = lerp( green(ca), green(cb), fraction);
  float b = lerp(  blue(ca),  blue(cb), fraction);
  
  //print(r+"\t"+g+"\t"+b+"\t"+i+" "+j+" "+f+"\n");
  return color(r,g,b);
}


int mand(Complex z0, int max) {
  Complex z = z0;
  for (int t = 0; t < max; ++t) {
      if (z.absSquared() > 4.0) return t;
      z = z.times(z).plus(z0);
  }
  return max;
}