void render(Environment env) {
  /*
    looks through an environment's list of valid coordinates and renders the live cells
  */
  background(#484340);

  for (int i = 0 ; i < env.coordList.length ; i++) {
    int x = env.coordList[i][0];
    int y = env.coordList[i][1];
    int z = env.coordList[i][2];

    if (env.habitat[x][y][z]) {
      axialPaint(x, y, z);
    }
  }
}
