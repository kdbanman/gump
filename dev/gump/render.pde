void render(Environment env) {
  renderTrans(env, -1, -1);
}

void renderTrans(Environment env, int planeSet, int plane) {
  /*
    looks through an environment's list of valid coordinates and renders the live cells
  */
  background(#484340);
  
  ambientLight(100, 100, 100);
  pointLight(300, 300, 300, 0, 0, 0);

  if (planeSet == -1 || plane == -1) {
    for (int i = 0 ; i < env.coordList.length ; i++) {
      int x = env.coordList[i][0];
      int y = env.coordList[i][1];
      int z = env.coordList[i][2];
  
      if (env.habitat[x][y][z] == 1) {
        axialPaint(x, y, z);
      }
    }
  } else {
      for (int i = 0 ; i < env.coordList.length ; i++) {
      int x = env.coordList[i][0];
      int y = env.coordList[i][1];
      int z = env.coordList[i][2];
      
      int cellPlaneSet;
      if (x%2 == 1) cellPlaneSet = 2;
      else if (y%2 == 1) cellPlaneSet = 1;
      else if (z%2 == 1) cellPlaneSet = 0;
      else cellPlaneSet = -1;  // this should never occur, based on coordList constructi
      
      boolean inFocus = false;
  
      // nested if blocks here for clarity of intent.  hopefully this isn't counterproductive...
      if (env.habitat[x][y][z] == 1) {
        if (planeSet == cellPlaneSet) {
          if (planeSet == 2 && x == plane 
           || planeSet == 1 && y == plane
           || planeSet == 0 && z == plane) {
             inFocus = true;
           }
        }
        if (inFocus) axialPaint(x, y, z);
        else axialPaintTrans(x, y, z, 20);
      }  
    }
  }
}
