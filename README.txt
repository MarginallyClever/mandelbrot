##### Mandelbrot #####

Mandelbrot fractal explorer written for Processing 3

## Instructions ##

Install Processing 3 if you don't have it: http://processing.org/
Open the mandelbrot.pde with Processing 3.
Run the program.

Moving the cursor will reveal the current cursor position and the zoom level.  A dot will also be shown in the center of the screen.

MOUSE CLICK to zoom in 10% on the point under the cursor.  Each zoom will print a line to the processing output window like this:

  xc=-0.7407339811325073;yc=-0.14992965757846832;zoom=0.030709465434152445;1043ms

Everything up to and including the third ';' can be copied to the end of setup() if you find a view you really like and want to return there or share with friends.  the ms on the end is the number of milliseconds to calculate the image you see.

SPACE BAR will pause the color animation.  This is mostly so you can take your time getting that perfect screenshot.

There is no zoom out or scroll sideways option.

## Get help ##

Please visit the forums at https://marginallyclever.com/forum if you have questions.

Pull requests always welcome!


## Special thanks ##

This code is adapted from an online example at http://introcs.cs.princeton.edu/java/32class/Mandelbrot.java.html
