import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 

import peasy.test.*; 
import peasy.org.apache.commons.math.*; 
import peasy.*; 
import peasy.org.apache.commons.math.geometry.*; 

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
int habitatSize = 50;

// Environment and renderer objects
Environment environment;

/************
  CONSTRUCTION CONTROL FLAGS AND PARAMETERS
************/

// Flag to indicate seed construction mode or iteration mode
boolean constructing = true;
// Shift key will fuck everything if this is initialized to true.
boolean freeConstCam = false;
CameraState beforeFree;

// Construction user interface
ConstructionCamera constrCam;

/************
  ITERATION MODE CONTROL FLAGS AND PARAMETERS
************/

// Number of frames to render between environmental iterations (need to have frameCounter for this to work)
// This is modified by division/multiplication by 2 to avoid negative values (WHY NO UNSIGNED INT, JAVA??) 
int framesPerIter = 64;
int frameCounter = 0;

/***********
  CAMERA FROM MRFEINBERG.COM
***********/

PeasyCam cam;

public void setup() {
  /*
    Processing's  initialization function
  */
  output = createWriter("../statData/population" + String.valueOf((int)(habitatSize * seedFraction)) + ".txt");

  environment = new Environment(habitatSize);
  environment.habitat = generate(environment.habitat, seedFraction, seedProbability, generateMode);
  
  size(1080, 720, OPENGL);
  
  hint(DISABLE_DEPTH_TEST);
  
  this.cam = new PeasyCam(this, 0);
  constrCam = new ConstructionCamera(environment, seedFraction, cam, width, height);
}


public void keyPressed()
{
  /*
    Processing's keyboard event handler.
    NOT relocated to a separate file, since main program logic is encoded here
  */
  if (key == 'q' || key == 'Q') {
      output.flush();
      output.close();
      exit();
  }
  if (constructing) {
    
    if (key == CODED) {
      if (!freeConstCam) {
        if (keyCode == UP) {
          constrCam.forward();
          
        } else if (keyCode == DOWN) {
          constrCam.backward();
          
        } else if (keyCode == LEFT) {
          constrCam.rotLeft();
          
        } else if (keyCode == RIGHT) {
          constrCam.rotRight();
        } else if (keyCode == SHIFT) {
          beforeFree = this.cam.getState();
          this.cam.setDistance(this.cam.getDistance() + 50);
          this.cam.setActive(true);
          freeConstCam = !freeConstCam;
        }
      } else if (keyCode == SHIFT) {
        this.cam.setState(beforeFree);
        this.cam.setActive(false);
        freeConstCam = !freeConstCam;
      }
    } else if (key == ENTER || key == RETURN) {
      constructing = false;
      cam.setActive(true);
      hint(ENABLE_DEPTH_TEST);
      
    } else if (key >= '1' && key <= '9') {
      int seedSize = key - 40;
      constrCam.generateFull(seedSize);     
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


public void mousePressed() {
  if (constructing && !freeConstCam) {
    constrCam.mouseToggle(mouseX, mouseY);
  }
}


public void draw() {
  /*
    Processing's main program loop
  */
  
  // start in seed construction mode, transition to evolution mode when done
  if (!constructing) {
    
    render(environment);
    
    if (frameCounter % framesPerIter == 0) {
      String[] datapoint = new String[2];
      datapoint[0] = str(environment.generation);
      datapoint[1] = str(environment.population);
      output.println( join(datapoint, "     ") );
      
      environment.iterate();
    }
    frameCounter++;
    
  } else {
    renderTrans(environment, constrCam.planeSet, constrCam.plane);
  }
  
  // key system variable
  //   not cleared by default, so set it to an unused value '~' before keyPressed() fills it
  key = '~';
  keyPressed();
  
}



public static class RotationCoordinate {
  private PeasyCam cam;
  private CameraState defState;
  
  private CameraState zeroCam;
  private CameraState oneCam;
  private CameraState twoCam;
  
  public RotationCoordinate(PeasyCam cam) {
    this.cam = cam;
    
    Rotation defRot = new Rotation();
    Vector3D defCenter = new Vector3D();
    double defDist = 10;
    this.defState = new CameraState(defRot, defCenter, defDist);
    
    this.zeroCam = this.defState;
    this.oneCam = this.defState;
    this.twoCam = this.defState;
  }
  
  public CameraState getZeroCam() {
    print("here\nhere\nhere\nhere\nhere\nhere");
    if ((this.zeroCam).equals(this.defState)) {
      CameraState curr = this.cam.getState();
      cam.setRotations(0, PI, 0);
      this.zeroCam = cam.getState();
      cam.setState(curr);
    }
    
    return this.zeroCam;
  }
  
  public CameraState getOneCam() {
    if ((this.oneCam).equals(this.defState)) {
      print("here\nhere\nhere\nhere\nhere\nhere");
      CameraState curr = this.cam.getState();
      cam.setRotations(PI/2, 0, 0);
      this.zeroCam = cam.getState();
      cam.setState(curr);
    }
    
    return this.oneCam;
  }
  
  public CameraState getTwoCam() {
    print("here\nhere\nhere\nhere\nhere\nhere");
    if ((this.twoCam).equals(this.defState)) {
      CameraState curr = this.cam.getState();
      cam.setRotations(0, 3*PI/2, 0);
      this.zeroCam = cam.getState();
      cam.setState(curr);
    }
    
    return this.twoCam;
  }
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
public static class ConstructionCamera {
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
   - mouse click on a cell toggles it
   - numerical values (designed for number keys) give a full seed
     roughly corresponding in size to the value of the key
   
   */


  // Flag to indicate plane set currently being constructed, 0 => xy, 1 => xz, 2 => yz
  private static int planeSet;
  // Rotation target for switching between planesets
  private static RotationCoordinate rotTarget;
  // Plane number within plane set currently being constructed
  //   can only be odd
  //   must be in interval centered in evronment ~38% its length (denoted by minPlane, maxPlane)
  private static int plane;
  private static int minPlane;
  private static int maxPlane;
  // Environment/camera UI will be manipulating
  private static Environment environ;
  private static PeasyCam cam;
  // Need to replace cam.getDistance() in places for rapid successive .forward() or .back() calls
  private static double camDist;
  // pixel boundaries where the environment occupies (based on 1080:720 ratio), Y boundaries are 0 and height, trivially
  private static int mouseXMin;
  private static int mouseXMax;
  private static int mouseYMin;
  private static int mouseYMax;
  // pixel dimension of each cell when in focussed plane
  private static int cellDim;

  public ConstructionCamera(Environment env, float fraction, PeasyCam cam, int windowW, int windowH) {
    this.environ = env;
    this.cam = cam;

    double middle = ((double) this.environ.dimSize) / 2 * 10 + 10;
    this.camDist = middle - 14;
    this.cam.setDistance(this.camDist);
    this.cam.lookAt(middle, middle, middle);
    this.cam.setMinimumDistance(0.01f);
    this.cam.setMaximumDistance(middle*2);
    this.cam.setSuppressRollRotationMode();
    this.cam.setActive(false);

    this.minPlane = env.getSeedStart(fraction);
    this.maxPlane = env.getSeedEnd(fraction);

    // initial focus on first seed plane of plane set xy
    this.planeSet = 0;
    this.rotTarget = new RotationCoordinate(this.cam);
    this.cam.setRotations(0, PI, 0);
    
    this.plane = minPlane;

    this.mouseXMin = (int) (0.162f * (float) windowW);
    this.mouseXMax = (int) ((1-0.162f) * (float) windowW);
    this.mouseYMin = 0;
    this.mouseYMax = windowH;

    this.cellDim = (this.mouseXMax - this.mouseXMin) / 9;
  }

  public void forward() {
    if (this.plane < this.maxPlane) {
      this.plane += 2;
      this.camDist -=20;
      this.cam.setDistance(this.camDist);
    }
  }

  public void backward() {
    if (this.plane > this.minPlane) {
      this.plane -= 2;
      this.camDist += 20;
      this.cam.setDistance(this.camDist);
    }
  }

  public void rotLeft() {
    if (this.planeSet == 0) {
      this.planeSet = 1;
      this.cam.setRotations(PI/2, 0, 0);
    } else if (this.planeSet == 1) {
      this.planeSet = 2;
      this.cam.setRotations(0, 3*PI/2, 0);
    } else {
      this.planeSet = 0;
      this.cam.setRotations(0, PI, 0);
    }
  }

  public void rotRight() {
    if (this.planeSet == 2) {
      this.planeSet = 1;
      this.cam.setRotations(PI/2, 0, 0);
    } 
    else if (this.planeSet == 0) {
      this.planeSet = 2;
      this.cam.setRotations(0, 3*PI/2, 0);
    } 
    else {
      this.planeSet = 0;
      this.cam.setRotations(0, PI, 0);
    }
  }

  public void mouseToggle(int mX, int mY) {
    // rendered pixel boundaries of environment cells for the in-focus plane are stored in mouseXMax, mouseYMax,
    // mouseXMin, mouseYMin.
    // there are 9 cells per linear dimension, so subtract the min from the mouse coord, divide by 9, and
    // then mod the width of each cell (84 pixels)
    if (mX <= mouseXMax && mX >= mouseXMin && mY <= mouseYMax && mY >= mouseYMin) {
      int clickX = 2 * ((mX - this.mouseXMin) / cellDim);
      int clickY = 2 * ((mY - this.mouseYMin) / cellDim);

      int xCoord = this.minPlane + 1;
      int yCoord = this.minPlane + 1;
      int zCoord = this.minPlane + 1;

      if (this.planeSet == 0) {
        xCoord -= clickX - this.maxPlane + this.minPlane + 2;
        yCoord += clickY;
        zCoord = this.plane;
      } 
      else if (this.planeSet == 1) {
        xCoord += clickX;
        yCoord = this.plane;
        zCoord += clickY;
      } 
      else {
        xCoord = this.plane;
        yCoord += clickY;
        zCoord += clickX;
      }

      this.environ.habitat[xCoord][yCoord][zCoord] = !this.environ.habitat[xCoord][yCoord][zCoord];
    }
  }

  public void generateFull(int seedSize) {
    // populate habitat with full cube of on cells of size seedSize

      for (int x = this.minPlane; x <= maxPlane; x++) {
      for (int y = this.minPlane; y <= maxPlane; y++) {
        for (int z = this.minPlane; z <= maxPlane; z++) {
          if (x%2 + y%2 + z%2 == 1) {
            this.environ.habitat[x][y][z] = false;
          }
        }
      }
    }

    int seedStart = this.environ.dimSize / 2 - seedSize / 2;
    int seedEnd = seedStart + seedSize;

    for (int x = seedStart ; x <= seedEnd ; x++) {
      for (int y = seedStart ; y <= seedEnd ; y++) {
        for (int z = seedStart ; z <= seedEnd ; z++) {
          if (x%2 + y%2 + z%2 == 1) {
            this.environ.habitat[x][y][z] = true;
          }
        }
      }
    }
  }
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
  int seedStart = getSeedStart(habitatGen, fraction);
  int seedEnd = getSeedEnd(habitatGen, fraction);

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

public int getSeedEnd(boolean[][][] habitatGen, float fraction) {
  float seedLength = habitatGen.length * fraction;
  
  int seedEnd =  round( habitatGen.length / 2 + seedLength / 2 );
  if (seedEnd % 2 == 0) seedEnd++;
  seedEnd = min(seedEnd, habitatGen.length - 1);
  
  return seedEnd;
}
public int getSeedStart(boolean[][][] habitatGen, float fraction) {
  float seedLength = habitatGen.length * fraction;
  
  int seedStart = round( habitatGen.length / 2 - seedLength / 2 );
  if (seedStart % 2 == 0) seedStart++;
  seedStart = min(seedStart, habitatGen.length - 1);
  
  return seedStart;
}
public void render(Environment env) {
  renderTrans(env, -1, -1);
}

public void renderTrans(Environment env, int planeSet, int plane) {
  /*
    looks through an environment's list of valid coordinates and renders the live cells
  */
  background(0xff484340);
  
  ambientLight(100, 100, 100);
  pointLight(300, 300, 300, 0, 0, 0);

  if (planeSet == -1 || plane == -1) {
    for (int i = 0 ; i < env.coordList.length ; i++) {
      int x = env.coordList[i][0];
      int y = env.coordList[i][1];
      int z = env.coordList[i][2];
  
      if (env.habitat[x][y][z]) {
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
      if (env.habitat[x][y][z]) {
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
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "gump" });
  }
}
