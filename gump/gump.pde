
PrintWriter output;
import processing.opengl.*;

/************************
  GLOBAL CONFIG VARIABLES
************************/

// Size of (toroidal) cubic habitat
int habitatSize = 32;

// Seed generation mode.  Seeds are always planted centrally in the environment.
//     1 for cube shape
//     2 for planar
int generateMode = 1;

// Seed size as fraction of the environment
float seedFraction = 0.3;

// Probability that any cell within the seed will become live (0 - 100)
int seedProbability = 50;

// Rendering mode.
//     1 for 3D, with a mouse controlled camera: L/R rotation, U/D zoom
//        Cells colorized based on orthogonality
//     2 for 2D, only a central plane is rendered
//        Live cells are orang.
//        'Whiteness' of a cell intensifies the more often that cell is alive
int renderMode = 1;

/*****************************************
  ENVIRONMENTAL AND STASTISTICAL VARIABLES
    while these are global variables, they will be passed as parameters to each function to
    improve clarity.
*****************************************/

// habitat arrays
//   at the beginning of each timestep, newHabitat is calculated from the (old) habitat
//   at the end of each timest
Environment environment = new Environment(habitatSize);
boolean[][][] habitat = new boolean[habitatSize][habitatSize][habitatSize];
boolean[][][] newHabitat = new boolean[habitatSize][habitatSize][habitatSize];

// list of all 3D cell coordinates allowed by the map restrictions (with only one odd of x,y,z) within habitat
// POST REFACTOR:  THIS IS PASSED THE INTEGER SIZE, not the actual habitat
int coordList[][] = coordGenerate(habitat);

// generation counter
int generation;
// population counter
int population;
// cumulative counter for each cell
int[][][] cellCount = new int[habitatSize][habitatSize][habitatSize];
int maxCount;

void setup() {

  output = createWriter("../statData/population" + String.valueOf((int)(habitatSize * seedFraction)) + ".txt");

  renderSet();

  background(#484340);

  habitat = generate(habitat, seedFraction, seedProbability, generateMode);
}

void draw() {

  population = 0;

  newHabitat = iterate(habitat, population);

  habitat = newHabitat;

  keyPressed();

  mouseCamera(renderMode);
  render(generation, renderMode);

  String[] datapoint = new String[2];
  datapoint[0] = str(generation);
  datapoint[1] = str(population);
  output.println( join(datapoint, "     ") );

  generation++;
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


