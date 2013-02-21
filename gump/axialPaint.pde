void axialPaint(int x, int y, int z) {
  /*
    colorize the rendered cells according to their plane set
  */
  if (x%2 == 1) {
    
    fill(#7595ac);
  } else {
    if (y%2 == 1) {
      
      fill(#6b7e51);
    } else {
      
      fill(#f5994e);
    }
    
  }

  cellDraw(x, y, z, 10);
}
