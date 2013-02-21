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
float seedFraction = 0.4;

// Probability that any cell within the seed will become live (0 - 100)
int seedProbability = 100;

/************
  ENVIRONMENT DECLARATION
************/

// Size of (toroidal) cubic, 3D habitat container.
//   for interface, guard from 1 to (N % 2 == 1 ? N : N - 1)
int habitatSize = 32;

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
int framesPerIter = 64;
int frameCounter = 0;


void setup() {
  /*
    Processing's  initialization function
  */
  output = createWriter("../statData/population" + String.valueOf((int)(habitatSize * seedFraction)) + ".txt");

  environment = new Environment(habitatSize);
  environment.habitat = generate(environment.habitat, seedFraction, seedProbability, generateMode);
  
  size(1280, 800, OPENGL);
  hint(DISABLE_DEPTH_TEST);
}


void keyPressed()
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
    } 
  } else {
    if (key == CODED) {
      if (keyCode == UP) {
        framesPerIter = max(1, framesPerIter / 2);
      } else if (keyCode == DOWN) {
        framesPerIter *= 2;
      }
    } else if (key == 'e' || key == 'E') {
      renderEmpty = !renderEmpty;
    }
  }
}


void draw() {
  /*
    Processing's main program loop
  */
  
  // start in seed construction mode, transition to evolution mode when done
  if (!constructing) {
    mouseCamera(environment, renderEmpty);
    
    if (frameCounter % framesPerIter == 0) {
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

  String[] datapoint = new String[2];
  datapoint[0] = str(environment.generation);
  datapoint[1] = str(environment.population);
  output.println( join(datapoint, "     ") );
  
}



