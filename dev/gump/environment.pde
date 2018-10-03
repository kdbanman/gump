import java.util.List;
import java.util.ArrayList;
import java.util.concurrent.Future;
import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ExecutionException;

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
  private static int[][][] habitat;
  private static int[][][] newHabitat;
  // size of 3D environment container
  public static int dimSize;
  // array of all valid coordinates (since not all cells in the above 3D arrays are environmental)
  public static int coordList[][];
  // current population
  public int population;
  // current generation
  public static int generation;
  // cumulative number of generations that each cell has been live
  
  private static int numThreads;
  private static List<PartialEnvironmentIterator> threads;
  private static ExecutorService threadPool;
  
  public Environment(int habSize)
  {
    /*
      constructor that defines its habitats and valid coordinates based on the passed size.
      (obviously) only supports cubic environments.
    */
    this.habitat = new int[habSize][habSize][habSize];
    this.newHabitat = new int[habSize][habSize][habSize];
    this.dimSize = habSize;
    this.coordList = coordGenerate(habSize);
    this.population = 0;
    this.generation = 0;
    
    this.numThreads = 6;
    this.threads = generateThreads();
    this.threadPool = Executors.newFixedThreadPool(this.numThreads);
  } // end constructor
  
  
  public int getSeedStart(float fraction) {
    /*
      returns the first plane in the central seed of fractional size passed
    */
    float seedLength = this.dimSize * fraction;
    
    int seedStart = round(this.dimSize / 2 - seedLength / 2 );
    if (seedStart % 2 == 0) seedStart++;
    seedStart = min(seedStart, this.dimSize - 1);
    
    return seedStart;
  }
  
  
  public int getSeedEnd(float fraction) {
    /*
      returns the last plane in the central seed of fractional size passed
    */
    float seedLength = this.dimSize * fraction;
    
    int seedEnd =  round(this.dimSize / 2 + seedLength / 2 );
    if (seedEnd % 2 == 0) seedEnd++;
    seedEnd = min(seedEnd, dimSize - 1);
    
    return seedEnd;
  }
  
  
  private boolean isCoord(int x,int y,int z)
  {
    /*
      returns true if coordinate within 3D array is an environmental coordinate (exactly one of x,y,z odd)
    */
    return (x%2 + y%2 + z%2 == 1);
  } // end isCoord
  
  
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
  
  private List<PartialEnvironmentIterator> generateThreads()
  {
    ArrayList<PartialEnvironmentIterator> threads = new ArrayList<PartialEnvironmentIterator>();
    int coordsPerThread = this.coordList.length / this.numThreads;
    int threadMinIndex = 0;
    for (int thread = 0; thread < this.numThreads - 1; thread++) {
      int threadMaxIndex = threadMinIndex + coordsPerThread;
      threads.add(new PartialEnvironmentIterator(threadMinIndex, threadMaxIndex, this.coordList, this.habitat, this.newHabitat));
      
      threadMinIndex = threadMaxIndex;
      threadMaxIndex += coordsPerThread;
    }
    threads.add(new PartialEnvironmentIterator(threadMinIndex, this.coordList.length, this.coordList, this.habitat, this.newHabitat));
    
    return threads;
  }
  
  
  public void iterate()
  {
    /*
      computes and returns the next environment based on the current one.
      modifies the following class variables:
        population
        newHabitat
        habitat
    */
    
    this.population = 0;
    
    try {
      List<Future<Integer>> futurePopulationAdds = this.threadPool.invokeAll(this.threads);
      for (Future<Integer> futurePopulationAdd : futurePopulationAdds) {
          this.population += futurePopulationAdd.get();
      }
    } catch (ExecutionException e) {
      println("OH SHIT");
      println("OH SHIT");
      println("OH SHIT");
    } catch (InterruptedException e) {
      println("OH SHIZ");
      println("OH SHIZ");
      println("OH SHIZ");
    }
    
    for (PartialEnvironmentIterator iterator : threads) {
      iterator.swapHabitats();
    }
    
    this.generation++;
    
    int[][][] tmp = this.habitat;
    this.habitat = newHabitat;
    this.newHabitat = tmp;
  }  //  end iterate
  
  class PartialEnvironmentIterator implements java.util.concurrent.Callable<Integer> {
    private int minCoordIndex;
    private int maxCoordIndex;
    private int[][] coordList;
    private int[][][] habitat; 
    private int[][][] newHabitat;
    
    PartialEnvironmentIterator(int minCoordIndex, int maxCoordIndex, int[][] coordList, int[][][] habitat, int[][][] newHabitat) {
      this.minCoordIndex = minCoordIndex;
      this.maxCoordIndex = maxCoordIndex;
      this.coordList = coordList;
      this.habitat = habitat;
      this.newHabitat = newHabitat;
    }
    
    public void swapHabitats() {  
      int[][][] tmp = this.habitat;
      this.habitat = newHabitat;
      this.newHabitat = tmp;
    }
    
    public Integer call() {
      int addedPopulation = 0;
      
      for (int i = this.minCoordIndex ; i < maxCoordIndex ; i++) {
    
        int x = this.coordList[i][0];
        int y = this.coordList[i][1];
        int z = this.coordList[i][2];
        
        int totalCount = 0;
    
        if (x%2 == 1) {
          totalCount += toroidal(this.habitat, x, y+2, z+2);
          totalCount += toroidal(this.habitat, x, y+2, z-2);
          totalCount += toroidal(this.habitat, x, y-2, z+2);
          totalCount += toroidal(this.habitat, x, y-2, z-2);
    
          totalCount += toroidal(this.habitat, x+1, y, z+1);
          totalCount += toroidal(this.habitat, x+1, y, z-1);
          totalCount += toroidal(this.habitat, x+1, y+1, z);
          totalCount += toroidal(this.habitat, x+1, y-1, z);
    
          totalCount += toroidal(this.habitat, x-1, y, z+1);
          totalCount += toroidal(this.habitat, x-1, y, z-1);
          totalCount += toroidal(this.habitat, x-1, y+1, z);
          totalCount += toroidal(this.habitat, x-1, y-1, z);
        } 
        else if (y%2 == 1) {
          totalCount += toroidal(this.habitat, x+2, y, z+2);
          totalCount += toroidal(this.habitat, x+2, y, z-2);
          totalCount += toroidal(this.habitat, x-2, y, z+2);
          totalCount += toroidal(this.habitat, x-2, y, z-2);
  
          totalCount += toroidal(this.habitat, x, y+1, z+1);
          totalCount += toroidal(this.habitat, x, y+1, z-1);
          totalCount += toroidal(this.habitat, x+1, y+1, z);
          totalCount += toroidal(this.habitat, x-1, y+1, z);
  
          totalCount += toroidal(this.habitat, x, y-1, z+1);
          totalCount += toroidal(this.habitat, x, y-1, z-1);
          totalCount += toroidal(this.habitat, x+1, y-1, z);
          totalCount += toroidal(this.habitat, x-1, y-1, z);
        }
        else if (z%2 == 1) {
          totalCount += toroidal(this.habitat, x+2, y+2, z);
          totalCount += toroidal(this.habitat, x-2, y+2, z);
          totalCount += toroidal(this.habitat, x+2, y-2, z);
          totalCount += toroidal(this.habitat, x-2, y-2, z);
  
          totalCount += toroidal(this.habitat, x+1, y, z+1);
          totalCount += toroidal(this.habitat, x-1, y, z+1);
          totalCount += toroidal(this.habitat, x, y+1, z+1);
          totalCount += toroidal(this.habitat, x, y-1, z+1);
  
          totalCount += toroidal(this.habitat, x+1, y, z-1);
          totalCount += toroidal(this.habitat, x-1, y, z-1);
          totalCount += toroidal(this.habitat, x, y+1, z-1);
          totalCount += toroidal(this.habitat, x, y-1, z-1);
        }
    
        if ((totalCount == 4 || totalCount == 5) && this.habitat[x][y][z] == 0) {
          this.newHabitat[x][y][z] = 1;
          addedPopulation++;
        } 
        else if ((totalCount == 3 || totalCount == 4 || totalCount == 5) && this.habitat[x][y][z] == 1) {
          this.newHabitat[x][y][z] = 1;
          addedPopulation++;
        }
        else {
          this.newHabitat[x][y][z] = 0;
        }
      }
      
      return addedPopulation;
    }

    private int toroidal(int[][][] habitatTor, int x, int y, int z) {
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
  }
  
}
