// overloading is for selective transparency when rendering for construction mode

void axialPaint(int x, int y, int z) {
  /*
    colorize the rendered cells according to their planeset
  */
  axialPaintTrans(x, y, z, 255);
}


void axialPaintTrans(int x, int y, int z, int trans) {
  /*
    colorize the rendered cells according to their plane set with transparency
  */
  
  noStroke();
  
  color b = color(117, 149, 172, trans);
  color g = color(107, 126, 81, trans);
  color r = color(245, 153, 78, trans);
  
  if (x%2 == 1) fill(b);
  else if (y%2 == 1) fill(g);
  else fill(r);

  cellDraw(x, y, z, 10);
}
