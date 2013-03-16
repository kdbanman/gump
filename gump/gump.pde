PrintWriter output;
import processing.opengl.*;

/************
  GENERATION ZERO PARAMETERS
************/

// Seed generation mode.  Seeds are always planted centrally in the environment.
//     1 for cube shape
//     2 for planar
int generateMode = 1;

// Seed size as fraction of the environment
float seedFraction = 0.38;

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

void setup() {
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


void keyPressed()
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
      
      if (keyCode == UP) {
        constrCam.forward();
        
      } else if (keyCode == DOWN) {
        constrCam.backward();
        
      } else if (keyCode == LEFT) {
        constrCam.rotLeft();
        
      } else if (keyCode == RIGHT) {
        constrCam.rotRight();
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


void mousePressed() {
  if (constructing) {
    constrCam.mouseToggle(mouseX, mouseY);
  }
}


void draw() {
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



