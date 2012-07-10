
PrintWriter output;
import processing.opengl.*;

// Size of (toroidal) cubic habitat
int habitatSize = 64;

// Seed generation mode.  Seeds are always planted centrally in the environment.
//     1 for cube shape
//     2 for planar
int generateMode = 1;

// Seed size as fraction of the environment
float seedFraction = .4;

// Probability that any cell within the seed will become live
int seedProbability = 14;

// Rendering mode.
//     1 for 3D, with a mouse controlled camera: L/R rotation, U/D zoom
//        Cells colorized based on orthogonality
//     2 for 2D, only a central plane is rendered
//        Live cells are orang.
//        'Whiteness' of a cell intensifies the more often that cell is alive
int renderMode = 1;

// Every Nth frame is rendered.  For performance under GPU bottleneck
int frameSkip = 1;

// Only renders if true.  For stats collection rather than visualization
boolean rendering = true;

//global habitat arrays
boolean[][][] habitat = new boolean[habitatSize][habitatSize][habitatSize];
boolean[][][] newHabitat = new boolean[habitatSize][habitatSize][habitatSize];

//list of all 3D cell coordinates allowed by the map restrictions (with only one odd of x,y,z) within habitat
int coordList[][] = coordGenerate(habitat);

//main generation counter
int generation;
int aliveNow;
int aliveLast;
int[][][] cellCount = new int[habitatSize][habitatSize][habitatSize];
int maxCount;

void setup() {

  output = createWriter("runData24by24allON.dat");


  renderSet();

  background(#000000);

  habitat = generate(habitat, seedFraction, seedProbability, generateMode);
}

void draw() {

  aliveNow = 0;

  newHabitat = iterate(habitat);



  habitat = newHabitat;

  keyPressed();

  if (generation % 1 == 0) {


    if (rendering) {

      mouseCamera(renderMode);
      render(frameSkip, generation, renderMode);
    }

    String[] datapoint = new String[2];
    datapoint[0] = str(generation);
    datapoint[1] = str(aliveNow);
    output.println( join(datapoint, "     ") );
  }

  generation++;
  aliveLast = aliveNow;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      output.flush();
      output.close();
      exit();
    }
  }
  if (mousePressed) {
    if (rendering == true) {
      rendering = false;
    }
    else {
      rendering = true;
    }
  }
}

