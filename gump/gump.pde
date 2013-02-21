PrintWriter output;
import processing.opengl.*;



// Seed generation mode.  Seeds are always planted centrally in the environment.
//     1 for cube shape
//     2 for planar
int generateMode = 1;

// Seed size as fraction of the environment
float seedFraction = 0.4;

// Probability that any cell within the seed will become live (0 - 100)
int seedProbability = 100;


// Size of (toroidal) cubic, 3D habitat container.
//   for interface, guard from 1 to (N % 2 == 1 ? N : N - 1)
int habitatSize = 32;

// Environment and renderer objects
Environment environment;


// Flag to indicate seed construction mode or iteration mode
boolean constructing = true;

// Flag to indicate whether or not empty cells are to be rendered
boolean renderEmpty = true;


void setup() {

  output = createWriter("../statData/population" + String.valueOf((int)(habitatSize * seedFraction)) + ".txt");

  environment = new Environment(habitatSize);
  environment.habitat = generate(environment.habitat, seedFraction, seedProbability, generateMode);
  
  size(800, 600, OPENGL);
  hint(DISABLE_DEPTH_TEST);
}


void keyPressed()
{
  
  if (key == 'q' || key == 'Q') {
      output.flush();
      output.close();
      exit();
  }
  if (constructing) {
    if (key == ENTER || key == RETURN) {
      constructing = false;
    } 
  } else {
    if (key == 'e' || key == 'E') {
      renderEmpty = !renderEmpty;
    }
  }
}


void draw() {

  if (!constructing) {
    mouseCamera(environment, renderEmpty);
    environment.iterate();
  } else {
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



