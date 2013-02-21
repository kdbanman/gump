
private static class Environment {
  /*
    this is an enviroment class, so that the iterate function may alter the habitat, the population, and
    potentially other things that the environment might like to know about itself
  */
  // current and next generations of environment
  boolean[][][] habitat;
  boolean[][][] newHabitat;
  // array of all valid coordinates (since not all cells in the above 3D arrays are environmental)
  int coordList[][];
  // current population
  int population;
  
  public Environment(int habSize)
  {
    /*
      constructor that defines its habitats and valid coordinates based on the passed size.
      (obviously) only supports cubic environments.
    */
    habitat = new boolean[habSize][habSize][habSize];
    newHabitat = new boolean[habSize][habSize][habSize];
    coordList = coordGenerate(habSize);
    population = 0;
  } // end constructor
  
  private static boolean isCoord(int x,int y,int z)
  {
    /*
      returns true if coordinate within 3D array is an environmental coordinate (exactly one of x,y,z odd)
    */
    return (x%2 + y%2 + z%2 == 1);
  } // end isCoord
  
  private static int[][] coordGenerate(int habSize)
  {
    /*
      generates a list of valid coordinates (for fast iteration) for a 3D container of passed size
    */
    int count = 0;
    // generate an initial list that's a bit too big, to be copied to the correct size before returning
    int listSize = habSize * habSize * habSize / 2;
    int preCoordinate[][] = new int[listSize][3];
  
    for (int x = 0 ; x < habSize ; x++) {
      for (int y = 0 ; y < habSize ; y++) {
        for (int z = 0 ; z < habSize ; z++) {
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
  } // end coordGenerate
  
}
