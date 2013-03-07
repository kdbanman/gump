import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class gump extends PApplet {

PrintWriter output;


/************
  GENERATION ZERO PARAMETERS
************/

// Seed generation mode.  Seeds are always planted centrally in the environment.
//     1 for cube shape
//     2 for planar
int generateMode = 1;

// Seed size as fraction of the environment
float seedFraction = 0.38f;

// Probability that any cell within the seed will become live (0 - 100)
int seedProbability = 100;

/************
  ENVIRONMENT DECLARATION
************/

// Size of (toroidal) cubic, 3D habitat container.
//   for interface, guard from 1 to (N % 2 == 1 ? N : N - 1)
int habitatSize = 100;

// Environment and renderer objects
Environment environment;

/************
  CONTROL FLAGS AND PARAMETERS
************/

// Flag to indicate seed construction mode or iteration mode
boolean constructing = true;

// Flag to indicate whether or not empty cells are to be rendered
boolean renderEmpty = true;

// Number of frames to render between environmental iterations (need to have frameCounter for this to work)
// This is modified by division/multiplication by 2 to avoid negative values (WHY NO UNSIGNED INT, JAVA??) 
int framesPerIter = 1;
int frameCounter = 0;


public void setup() {
  /*
    Processing's  initialization function
  */
  output = createWriter("../statData/population" + String.valueOf((int)(habitatSize * seedFraction)) + ".txt");

  environment = new Environment(habitatSize);
  environment.habitat = generate(environment.habitat, seedFraction, seedProbability, generateMode);
  
  size(1280, 800, OPENGL);
  hint(DISABLE_DEPTH_TEST);
}


public void keyPressed()
{
  /*
    Processing's keyboard event handler.
    NOT relocated to a separate file, since key program logic is encoded here
  */
  if (key == 'q' || key == 'Q') {
      output.flush();
      output.close();
      exit();
  }
  if (constructing) {
    if (key == ENTER || key == RETURN) {
      constructing = false;
      renderEmpty = false;
      hint(ENABLE_DEPTH_TEST);
    } 
  } else {
    if (key == CODED) {
      if (keyCode == UP) {
        framesPerIter = max(1, framesPerIter / 2);
      } else if (keyCode == DOWN) {
        framesPerIter *= 2;
      }
    }
  }
}


public void draw() {
  /*
    Processing's main program loop
  */
  
  // start in seed construction mode, transition to evolution mode when done
  if (!constructing) {
    //mouseCamera(environment, renderEmpty);
    print(environment.generation);
    print("\n");
    print(environment.population);
    print("\n\n");
    
    
    
    if (frameCounter % framesPerIter == 0) {
      String[] datapoint = new String[2];
      datapoint[0] = str(environment.generation);
      datapoint[1] = str(environment.population);
      output.println( join(datapoint, "     ") );
      
      environment.iterate();
    }
    frameCounter++;
    
  } else {
    // IMPORTANT:  constructionCamera's functionality depends upon the key system variable
    constructionCamera(environment);
  }
  
  // key system variable is not cleared by default, so set it to an unused value '~' before keyPressed() fills it
  key = '~';
  keyPressed();
  
}



// overloading is for selective transparency when rendering for construction mode

public void axialPaint(int x, int y, int z) {
  /*
    colorize the rendered cells according to their plane set
  */
  axialPaintTrans(x, y, z, 255);
}


public void axialPaintTrans(int x, int y, int z, int trans) {
  /*
    colorize the rendered cells according to their plane set with transparency
  */
  
  noStroke();
  
  int b = color(117, 149, 172, trans);
  int g = color(107, 126, 81, trans);
  int r = color(245, 153, 78, trans);
  
  if (x%2 == 1) fill(b);
  else if (y%2 == 1) fill(g);
  else fill(r);

  cellDraw(x, y, z, 10);
}
public void cellDraw(int preX, int preY, int preZ, int scaling) {
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
public void constructionCamera(Environment env) {
  /*
    gui for constructing seeds.  only one plane is in focus at a time, mouse click on cells toggle them. 
    camera properties:
      - always orthogonal to one of the plane sets.
      - left and right arrows control rotation for focus on particular plane sets.
      - up and down arrows control forward and back movement
        - maintain distance from plane in focus for consistency of mouse click locations
        - never get close enough for cutoff bug
    render properties:
      - focused planes are the only ones rendered without transparency
      - up and down arrows control focus on particular planes.
    data controls:
      - mouse click on a cell toggles
      - mouse dragged across cells toggles 
      - 'c' clears entire seed
    
    IMPORTANT:  this function depends upon the system variable key
  */
  mouseCamera(env, true);
}

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
public boolean[][][] generate(boolean[][][] habitatGen, float fraction, int probability, int mode) {

  // generate the first and last indices of the seed, odd for plane enclosure
  float seedLength = habitatGen.length * fraction;
  
  int seedStart = round( habitatGen.length / 2 - seedLength / 2 );
  if (seedStart % 2 == 0) seedStart++;
  seedStart = min(seedStart, habitatGen.length - 1);
  
  int seedEnd =  round( habitatGen.length / 2 + seedLength / 2 );
  if (seedEnd % 2 == 0) seedEnd++;
  seedEnd = min(seedEnd, habitatGen.length - 1);

  if (mode == 1) {
    // full cube of on cells
    for (int x = seedStart ; x <= seedEnd ; x++) {
      for (int y = seedStart ; y <= seedEnd ; y++) {
        for (int z = seedStart ; z <= seedEnd ; z++) {
          if ((x%2 + y%2 + z%2 == 1)  &&  random(100) >= (100 - probability)) {

            habitatGen[x][y][z] = true;
          }
        }
      }
    }
  }

  else if (mode == 2) {
    // flat plane of on cells
    int z = round(habitatGen.length / 2);
    if (z % 2 == 1) z++;

    for (int x = seedStart ; x <= seedEnd ; x++) {
      for (int y = seedStart ; y <= seedEnd ; y++) {
        if ((x%2 + y%2 + z%2 == 1)  &&  random(100) >= (100 - probability)) {

          habitatGen[x][y][z] = true;
        }
      }
    }
  }

  return habitatGen;
}

public void mouseCamera(Environment env, boolean emptyCells) 
{
  /*
    camera that reacts to mouse movement, for when the environment is evolving
  */
  float cameraY = height/0.5f;
  float fov = mouseY/PApplet.parseFloat(width) * PI/2;
  float cameraZ = cameraY / tan(fov / 2.0f);
  float aspect = PApplet.parseFloat(width)/PApplet.parseFloat(height);
  perspective(fov, aspect, cameraZ/50.0f, cameraZ);

  translate(width/2, height/2, 0);
  rotateX(-PI/6);
  rotateY(PI/3 + mouseX/PApplet.parseFloat(height) * PI);
  
  render(env, emptyCells);
}
public void render(Environment env, boolean emptyCells) {
  /*
    looks through an environment's list of valid coordinates and renders the live cells
  */
  background(0xff484340);
  
  ambientLight(100, 100, 100);
  pointLight(300, 300, 300, 0, 0, 0);

  for (int i = 0 ; i < env.coordList.length ; i++) {
    int x = env.coordList[i][0];
    int y = env.coordList[i][1];
    int z = env.coordList[i][2];

    if (env.habitat[x][y][z]) {
      axialPaint(x, y, z);
    } else if (emptyCells) {
      axialPaintTrans(x,y,z,20);
    }
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--stop-color=#cccccc", "gump" });
  }
}
