
PrintWriter output;
import processing.opengl.*;

//control parameters
int habitatSize = 100;

//BUG:  shit.

int generateMode = 1;
float seedFraction = .4;
int seedProbability = 15;

int renderMode = 1;
int frameSkip = 1;
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

