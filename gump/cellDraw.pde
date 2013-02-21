void cellDraw(int preX, int preY, int preZ, int scaling) {
  /*
    render rectangles oriented according to their plane set, and scaled to a nice size
  */
  int x = preX * scaling;
  int y = preY * scaling;
  int z = preZ * scaling;
  
  // tranlation amoint to accomodate the scaling factor
  int vertexShift = scaling/2;

  beginShape();
  if (preX%2 == 1) {
    vertex(x, y+vertexShift, z+vertexShift);
    vertex(x, y+vertexShift, z-vertexShift);
    vertex(x, y-vertexShift, z-vertexShift);
    vertex(x, y-vertexShift, z+vertexShift);
  } 
  else { 
    if (preY%2 == 1) {
      vertex(x+vertexShift, y, z+vertexShift);
      vertex(x+vertexShift, y, z-vertexShift);
      vertex(x-vertexShift, y, z-vertexShift);
      vertex(x-vertexShift, y, z+vertexShift);
    } 
    else {
      vertex(x+vertexShift, y+vertexShift, z);
      vertex(x+vertexShift, y-vertexShift, z);
      vertex(x-vertexShift, y-vertexShift, z);
      vertex(x-vertexShift, y+vertexShift, z);
    }
  }
  endShape(CLOSE);
}
