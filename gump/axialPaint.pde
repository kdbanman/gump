void axialPaint(int x, int y, int z) {
/*  FOREST  */
/*
  if (x%2 == 1) {
    
    fill(#8CA23E);
  } else {
    if (y%2 == 1) {
      
      fill(#6D6B2E);
    } else {
      
      fill(#4F543E);
    }
    
  }
*/
/*  ORGANIC  */
/*
  if (x%2 == 1) {
    
    fill(#7595ac);
  } else {
    if (y%2 == 1) {
      
      fill(#6b7e51);
    } else {
      
      fill(#f5994e);
    }
    
  }
*/
/*  VEGETABLE  */

  if (x%2 == 1) {
    fill(#a3d8d6);
  } else if (y%2 == 1) {
    fill(#e4e566);
  } else {
    fill(#a0d857);
  }


    cellDraw(x, y, z, 10);
}
