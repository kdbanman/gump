// this is an enviroment class, so that the iterate function may alter the habitat, the population, and
// potentially other things that the environment might like to know about itself

private static class Environment {
  // current and next generations of environment
  boolean[][][] habitat;
  boolean[][][] newHabitat;
  // array of all valid coordinates (since not all cells in the above 3D arrays are environmental)
  int coordList[][];
  // current population
  int population;
  
  public Environment(int habSize) {
    habitat = new boolean[habSize][habSize][habSize];
    newHabitat = new boolean[habSize][habSize][habSize];
    //int coordList[][] = coordGenerate(habitat);
    population = 0;
  }
  
  private static boolean isCoord(int x,int y,int z) {
    return (x%2 + y%2 + z%2 == 1);
  }
  
  
}
