boolean[][][] iterate(boolean[][][] habitatIter) {

  population = 0;
  boolean[][][] iterated = new boolean[habitatIter.length][habitatIter.length][habitatIter.length];

  for (int i = 0 ; i < coordList.length ; i++) {

    int x = coordList[i][0];
    int y = coordList[i][1];
    int z = coordList[i][2];
    int count[] = new int[12];

    if (x%2 == 1) {

      count[0] = toroidal(habitatIter, x, y+2, z+2)?1:0;
      count[1] = toroidal(habitatIter, x, y+2, z-2)?1:0;
      count[2] = toroidal(habitatIter, x, y-2, z+2)?1:0;
      count[3] = toroidal(habitatIter, x, y-2, z-2)?1:0;

      count[4] = toroidal(habitatIter, x+1, y, z+1)?1:0;
      count[5] = toroidal(habitatIter, x+1, y, z-1)?1:0;
      count[6] = toroidal(habitatIter, x+1, y+1, z)?1:0;
      count[7] = toroidal(habitatIter, x+1, y-1, z)?1:0;

      count[8] = toroidal(habitatIter, x-1, y, z+1)?1:0;
      count[9] = toroidal(habitatIter, x-1, y, z-1)?1:0;
      count[10] = toroidal(habitatIter, x-1, y+1, z)?1:0;
      count[11] = toroidal(habitatIter, x-1, y-1, z)?1:0;
    } 
    else {
      if (y%2 == 1) {

        count[0] = toroidal(habitatIter, x+2, y, z+2)?1:0;
        count[1] = toroidal(habitatIter, x+2, y, z-2)?1:0;
        count[2] = toroidal(habitatIter, x-2, y, z+2)?1:0;
        count[3] = toroidal(habitatIter, x-2, y, z-2)?1:0;

        count[4] = toroidal(habitatIter, x, y+1, z+1)?1:0;
        count[5] = toroidal(habitatIter, x, y+1, z-1)?1:0;
        count[6] = toroidal(habitatIter, x+1, y+1, z)?1:0;
        count[7] = toroidal(habitatIter, x-1, y+1, z)?1:0;

        count[8] = toroidal(habitatIter, x, y-1, z+1)?1:0;
        count[9] = toroidal(habitatIter, x, y-1, z-1)?1:0;
        count[10] = toroidal(habitatIter, x+1, y-1, z)?1:0;
        count[11] = toroidal(habitatIter, x-1, y-1, z)?1:0;
      } 
      else {
        if (z%2 == 1) {

          count[0] = toroidal(habitatIter, x+2, y+2, z)?1:0;
          count[1] = toroidal(habitatIter, x-2, y+2, z)?1:0;
          count[2] = toroidal(habitatIter, x+2, y-2, z)?1:0;
          count[3] = toroidal(habitatIter, x-2, y-2, z)?1:0;

          count[4] = toroidal(habitatIter, x+1, y, z+1)?1:0;
          count[5] = toroidal(habitatIter, x-1, y, z+1)?1:0;
          count[6] = toroidal(habitatIter, x, y+1, z+1)?1:0;
          count[7] = toroidal(habitatIter, x, y-1, z+1)?1:0;

          count[8] = toroidal(habitatIter, x+1, y, z-1)?1:0;
          count[9] = toroidal(habitatIter, x-1, y, z-1)?1:0;
          count[10] = toroidal(habitatIter, x, y+1, z-1)?1:0;
          count[11] = toroidal(habitatIter, x, y-1, z-1)?1:0;
        }
      }
    }

    int totalCount = 0;
    for (int s = 0 ; s < 12 ; s++) {
      totalCount += count[s];
    }

    if ((totalCount == 4 | totalCount == 5) & !habitatIter[x][y][z]) {

      iterated[x][y][z] = true;
      
      population++;
      
      cellCount[x][y][z]++;
      maxCount = max(maxCount, cellCount[x][y][z]);
    } 
    else {
      if ( (totalCount == 3 | totalCount == 4 | totalCount == 5) & habitatIter[x][y][z]) {

        iterated[x][y][z] = true;
        
        population++;
        
        cellCount[x][y][z]++;
        maxCount = max(maxCount, cellCount[x][y][z]);
      }
    }
  }

  return iterated;
}
