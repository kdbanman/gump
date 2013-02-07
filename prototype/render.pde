void render(int perFrame, int iterations, int mode) {

  if (iterations % perFrame == 0) {
    background(#000000);

    if (mode == 1) {
      for (int i = 0 ; i < coordList.length ; i++) {

        int x = coordList[i][0];
        int y = coordList[i][1];
        int z = coordList[i][2];

        if (habitat[x][y][z]) {
          axialPaint(x, y, z);
        } 
        else {

          //render empty environment
          if (x%20 == 0 | y%20 == 0 | z%20 == 0) {
            //stroke(#1A1919);
            //point(4*x, 4*y, 4*z);
          }
        }
      }
    }

    if (mode == 2) {

      if (!keyPressed) {
        
        int z = round(habitat.length / 2);

        for (int x = 0 ; x < habitat.length ; x++) {
          for (int y = 0 ; y < habitat.length ; y++) { 

            if (habitat[x][y][z]) {

              fill(#FFC400);
              rect(5*x, 5*y, 5, 5);
            } 
            else {

              int shade = round(cellCount[x][y][z] * 256 / maxCount);
              fill(shade);
              rect(5*x, 5*y, 3, 3);
            }
          }
        }
      }
      else {

        int x = round(habitat.length / 2);

        for (int z = 0 ; z < habitat.length ; z++) {
          for (int y = 0 ; y < habitat.length ; y++) { 

            if (habitat[x][y][z]) {

              fill(#00FFAC);
              rect(5*z, 5*y, 5, 5);
            } 
            else {

              int shade = round(cellCount[x][y][z] * 256 / maxCount);
              fill(shade);
              rect(5*z, 5*y, 5, 5);
            }
          }
        }
      }
    }
  }
}

