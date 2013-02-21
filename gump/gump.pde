PrintWriter output;
import processing.opengl.*;

/************************
  GLOBAL CONFIG VARIABLES
************************/

// Size of (toroidal) cubic, 3D habitat container.
//   for interface, guard from 1 to (N % 2 == 1 ? N : N - 1)
int habitatSize = 14;

// Seed generation mode.  Seeds are always planted centrally in the environment.
//     1 for cube shape
//     2 for planar
int generateMode = 1;

// Seed size as fraction of the environment
float seedFraction = 0.7;

// Probability that any cell within the seed will become live (0 - 100)
int seedProbability = 100;

// Environment and renderer objects
Environment environment;

void setup() {

  output = createWriter("../statData/population" + String.valueOf((int)(habitatSize * seedFraction)) + ".txt");

  environment = new Environment(habitatSize);
  environment.habitat = generate(environment.habitat, seedFraction, seedProbability, generateMode);
  
  size(800, 600, OPENGL);
}

void draw() {

  environment.iterate();

  keyPressed();

  mouseCamera();
  render(environment);

  String[] datapoint = new String[2];
  datapoint[0] = str(environment.generation);
  datapoint[1] = str(environment.population);
  output.println( join(datapoint, "     ") );
  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      output.flush();
      output.close();
      exit();
    }
  }
}


