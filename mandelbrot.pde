// code is a variation of http://introcs.cs.princeton.edu/java/32class/Mandelbrot.java.html
// converted to processing example by dan royer (dan@marginallyclever.com) 2017-09-28
//---------------------------------------------------------------

public class Complex {
    private final double re;   // the real part
    private final double im;   // the imaginary part

    // create a new object with the given real and imaginary parts
    public Complex(double real, double imag) {
        re = real;
        im = imag;
    }

    // return a string representation of the invoking Complex object
    public String toString() {
        if (im == 0) return re + "";
        if (re == 0) return im + "i";
        if (im <  0) return re + " - " + (-im) + "i";
        return re + " + " + im + "i";
    }

    // return abs/modulus/magnitude
    public double abs() {
        return Math.hypot(re, im);
    }
    public double absSquared() {
        return (re*re + im*im);
    }

    // return angle/phase/argument, normalized to be between -pi and pi
    public double phase() {
        return Math.atan2(im, re);
    }

    // return a new Complex object whose value is (this + b)
    public Complex plus(Complex b) {
        Complex a = this;             // invoking object
        double real = a.re + b.re;
        double imag = a.im + b.im;
        return new Complex(real, imag);
    }

    // return a new Complex object whose value is (this - b)
    public Complex minus(Complex b) {
        Complex a = this;
        double real = a.re - b.re;
        double imag = a.im - b.im;
        return new Complex(real, imag);
    }

    // return a new Complex object whose value is (this * b)
    public Complex times(Complex b) {
        Complex a = this;
        double real = a.re * b.re - a.im * b.im;
        double imag = a.re * b.im + a.im * b.re;
        return new Complex(real, imag);
    }

    // return a new object whose value is (this * alpha)
    public Complex scale(double alpha) {
        return new Complex(alpha * re, alpha * im);
    }

    // return a new Complex object whose value is the conjugate of this
    public Complex conjugate() {
        return new Complex(re, -im);
    }

    // return a new Complex object whose value is the reciprocal of this
    public Complex reciprocal() {
        double scale = re*re + im*im;
        return new Complex(re / scale, -im / scale);
    }

    // return the real or imaginary part
    public double re() { return re; }
    public double im() { return im; }

    // return a / b
    public Complex divides(Complex b) {
        Complex a = this;
        return a.times(b.reciprocal());
    }

    // return a new Complex object whose value is the complex exponential of this
    public Complex exp() {
        return new Complex(Math.exp(re) * Math.cos(im), Math.exp(re) * Math.sin(im));
    }

    // return a new Complex object whose value is the complex sine of this
    public Complex sin() {
        return new Complex(Math.sin(re) * Math.cosh(im), Math.cos(re) * Math.sinh(im));
    }

    // return a new Complex object whose value is the complex cosine of this
    public Complex cos() {
        return new Complex(Math.cos(re) * Math.cosh(im), -Math.sin(re) * Math.sinh(im));
    }

    // return a new Complex object whose value is the complex tangent of this
    public Complex tan() {
        return sin().divides(cos());
    }
    


    // a static version of plus
    public Complex plus(Complex a, Complex b) {
        double real = a.re + b.re;
        double imag = a.im + b.im;
        Complex sum = new Complex(real, imag);
        return sum;
    }

    // See Section 3.3.
    public boolean equals(Object x) {
        if (x == null) return false;
        if (this.getClass() != x.getClass()) return false;
        Complex that = (Complex) x;
        return (this.re == that.re) && (this.im == that.im);
    }
/*
    // See Section 3.3.
    public int hashCode() {
        return Objects.hash(re, im);
    }

    // sample client for testing
    public static void main(String[] args) {
        Complex a = new Complex(5.0, 6.0);
        Complex b = new Complex(-3.0, 4.0);

        StdOut.println("a            = " + a);
        StdOut.println("b            = " + b);
        StdOut.println("Re(a)        = " + a.re());
        StdOut.println("Im(a)        = " + a.im());
        StdOut.println("b + a        = " + b.plus(a));
        StdOut.println("a - b        = " + a.minus(b));
        StdOut.println("a * b        = " + a.times(b));
        StdOut.println("b * a        = " + b.times(a));
        StdOut.println("a / b        = " + a.divides(b));
        StdOut.println("(a / b) * b  = " + a.divides(b).times(b));
        StdOut.println("conj(a)      = " + a.conjugate());
        StdOut.println("|a|          = " + a.abs());
        StdOut.println("tan(a)       = " + a.tan());
    }
*/
}


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
