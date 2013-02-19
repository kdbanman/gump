void renderSet () {

  if (renderMode == 1) {
    size(800, 600, OPENGL);
  }
  if (renderMode == 2) {
    size(habitat.length*5, habitat.length*5);
    noStroke();
  }
}

