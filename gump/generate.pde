boolean[][][] generate(boolean[][][] habitatGen, float fraction, int probability, int mode) {

  // generate the first and last indices of the seed, odd for plane enclosure
  float seedLength = habitatGen.length * fraction;
  
  int seedStart = round( habitatGen.length / 2 - seedLength / 2 );
  if (seedStart % 2 == 0) seedStart++;
  seedStart = min(seedStart, habitatGen.length - 1);
  
  int seedEnd =  round( habitatGen.length / 2 + seedLength / 2 );
  if (seedEnd % 2 == 0) seedEnd++;
  seedEnd = min(seedEnd, habitatGen.length - 1);

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

