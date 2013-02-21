int[][] coordGenerate(boolean[][][] habitatCoord) {

  int count = 0;
  int listSize = habitatCoord.length * habitatCoord.length * habitatCoord.length / 2;
  int preCoordinate[][] = new int[listSize][3];

  for (int x = 0 ; x < habitatCoord.length ; x++) {
    for (int y = 0 ; y < habitatCoord.length ; y++) {
      for (int z = 0 ; z < habitatCoord.length ; z++) {
        if (isCoord(x,y,z)) {

          preCoordinate[count][0] = x;
          preCoordinate[count][1] = y;
          preCoordinate[count][2] = z;

          count++;
        }
      }
    }
  }

  int coordinate[][] = new int[count+1][3];

  for (int i = 0 ; i < count ; i ++) {

    coordinate[i] = preCoordinate[i];
  }
  
  return coordinate;
}
