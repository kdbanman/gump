
public static class Environment {
  /*
    this is an enviroment class.
    
    it describes Gump with a 3D array model where the set of valid coordinates are those
    where exactly one is odd.  the odd dimension denotes the plane set.  EX: say
    a cell has (x,y,z) == (1,2,4).  since x is odd, the cell exists on the yz plane set.
    
    an array of valid coordinates within this 3D model (exactly one odd) is kept, so that
    the ith element is a length 3 array, denoting the (x,y,z) position of the ith element in
    x-supermajor, y-major ordering.
    
    various statistics, like current population and cumulative cell life counts are kept
  */
  
  
  // 3D containers for current and next generations of environment
  //   when iterate() is called, newHabitat is calculated, then habitat is set equal to newHabitat
  public static boolean[][][] habitat;
  private static boolean[][][] newHabitat;
  // size of 3D environment container
  public static int dimSize;
  // array of all valid coordinates (since not all cells in the above 3D arrays are environmental)
  public static int coordList[][];
  // current population
  public int population;
  // current generation
  public static int generation;
  // cumulative number of generations that each cell has been live
  public static int cellCount[][][];
  // current maximum within cellCount
  public static int maxCount;
  
  public Environment(int habSize)
  {
    /*
      constructor that defines its habitats and valid coordinates based on the passed size.
      (obviously) only supports cubic environments.
    */
    this.habitat = new boolean[habSize][habSize][habSize];
    this.newHabitat = new boolean[habSize][habSize][habSize];
    this.dimSize = habSize;
    this.coordList = coordGenerate(habSize);
    this.population = 0;
    this.generation = 0;
    this.cellCount = new int[habSize][habSize][habSize];
    this.maxCount = 0;
  } // end constructor
  
  
  private boolean isCoord(int x,int y,int z)
  {
    /*
      returns true if coordinate within 3D array is an environmental coordinate (exactly one of x,y,z odd)
    */
    return (x%2 + y%2 + z%2 == 1);
  } // end isCoord
  
  
  private boolean toroidal(boolean[][][] habitatTor, int x, int y, int z) {
    /*
      calculates the passed coordinate mod the environment size (for toroidal environment property).
      necessary because processing handles negative mod strangely.
    */
    //if the array indices called are out of bounds by integer > 0, return their toroidal counterparts
    int xTrans = (x < 0) ? (habitatTor.length + x) : ( (x >= habitatTor.length)?(x - habitatTor.length):x );
    int yTrans = (y < 0) ? (habitatTor.length + y) : ( (y >= habitatTor.length)?(y - habitatTor.length):y );
    int zTrans = (z < 0) ? (habitatTor.length + z) : ( (z >= habitatTor.length)?(z - habitatTor.length):z );
  
    return habitatTor[xTrans][yTrans][zTrans];
  }
  
  
  private int[][] coordGenerate(int habSize)
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
  
  
  public void iterate()
  {
    /*
      computes and returns the next environment based on the current one.
      modifies the following class variables:
        population
        maxCount
        cellCount
        newHabitat
        habitat
    */
    
    this.population = 0;
  
    for (int i = 0 ; i < coordList.length ; i++) {
  
      int x = coordList[i][0];
      int y = coordList[i][1];
      int z = coordList[i][2];
      
      this.newHabitat[x][y][z] = false;
      
      int count[] = new int[12];
  
      if (x%2 == 1) {
  
        count[0] = toroidal(this.habitat, x, y+2, z+2)?1:0;
        count[1] = toroidal(this.habitat, x, y+2, z-2)?1:0;
        count[2] = toroidal(this.habitat, x, y-2, z+2)?1:0;
        count[3] = toroidal(this.habitat, x, y-2, z-2)?1:0;
  
        count[4] = toroidal(this.habitat, x+1, y, z+1)?1:0;
        count[5] = toroidal(this.habitat, x+1, y, z-1)?1:0;
        count[6] = toroidal(this.habitat, x+1, y+1, z)?1:0;
        count[7] = toroidal(this.habitat, x+1, y-1, z)?1:0;
  
        count[8] = toroidal(this.habitat, x-1, y, z+1)?1:0;
        count[9] = toroidal(this.habitat, x-1, y, z-1)?1:0;
        count[10] = toroidal(this.habitat, x-1, y+1, z)?1:0;
        count[11] = toroidal(this.habitat, x-1, y-1, z)?1:0;
      } 
      else {
        if (y%2 == 1) {
  
          count[0] = toroidal(this.habitat, x+2, y, z+2)?1:0;
          count[1] = toroidal(this.habitat, x+2, y, z-2)?1:0;
          count[2] = toroidal(this.habitat, x-2, y, z+2)?1:0;
          count[3] = toroidal(this.habitat, x-2, y, z-2)?1:0;
  
          count[4] = toroidal(this.habitat, x, y+1, z+1)?1:0;
          count[5] = toroidal(this.habitat, x, y+1, z-1)?1:0;
          count[6] = toroidal(this.habitat, x+1, y+1, z)?1:0;
          count[7] = toroidal(this.habitat, x-1, y+1, z)?1:0;
  
          count[8] = toroidal(this.habitat, x, y-1, z+1)?1:0;
          count[9] = toroidal(this.habitat, x, y-1, z-1)?1:0;
          count[10] = toroidal(this.habitat, x+1, y-1, z)?1:0;
          count[11] = toroidal(this.habitat, x-1, y-1, z)?1:0;
        } 
        else {
          if (z%2 == 1) {
  
            count[0] = toroidal(this.habitat, x+2, y+2, z)?1:0;
            count[1] = toroidal(this.habitat, x-2, y+2, z)?1:0;
            count[2] = toroidal(this.habitat, x+2, y-2, z)?1:0;
            count[3] = toroidal(this.habitat, x-2, y-2, z)?1:0;
  
            count[4] = toroidal(this.habitat, x+1, y, z+1)?1:0;
            count[5] = toroidal(this.habitat, x-1, y, z+1)?1:0;
            count[6] = toroidal(this.habitat, x, y+1, z+1)?1:0;
            count[7] = toroidal(this.habitat, x, y-1, z+1)?1:0;
  
            count[8] = toroidal(this.habitat, x+1, y, z-1)?1:0;
            count[9] = toroidal(this.habitat, x-1, y, z-1)?1:0;
            count[10] = toroidal(this.habitat, x, y+1, z-1)?1:0;
            count[11] = toroidal(this.habitat, x, y-1, z-1)?1:0;
          }
        }
      }
  
      int totalCount = 0;
      for (int s = 0 ; s < 12 ; s++) {
        totalCount += count[s];
      }
  
      if ((totalCount == 4 | totalCount == 5) & !this.habitat[x][y][z]) {
  
        this.newHabitat[x][y][z] = true;
        
        this.population++;
        
        this.cellCount[x][y][z]++;
        this.maxCount = max(this.maxCount, this.cellCount[x][y][z]);
      } 
      else {
        if ( (totalCount == 3 | totalCount == 4 | totalCount == 5) & this.habitat[x][y][z]) {
  
          this.newHabitat[x][y][z] = true;
          
          this.population++;
          
          this.cellCount[x][y][z]++;
          this.maxCount = max(this.maxCount, this.cellCount[x][y][z]);
        } 
      }
    }
    
    this.generation++;
    
    for (int i = 0 ; i < coordList.length ; i++) {
      int x = coordList[i][0];
      int y = coordList[i][1];
      int z = coordList[i][2];
      this.habitat[x][y][z] = this.newHabitat[x][y][z];
    }
  }  //  end iterate
  
  
  
  
}
