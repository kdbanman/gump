void axialPaint(int x, int y, int z) {
  
  if (x%2 == 1) {
    
    fill(#FF0000);
  } else {
    if (y%2 == 1) {
      
      fill(#0006FF);
    } else {
      
      fill(#03FF00);
    }
    
  }
  
    cellDraw(x, y, z, 10);
}
