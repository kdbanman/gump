int getSeedStart(int[][][] habitatGen, float fraction) {
  float seedLength = habitatGen.length * fraction;
  
  int seedStart = round( habitatGen.length / 2 - seedLength / 2 );
  if (seedStart % 2 == 0) seedStart++;
  seedStart = min(seedStart, habitatGen.length - 1);
  
  return seedStart;
}
