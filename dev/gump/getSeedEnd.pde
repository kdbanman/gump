int getSeedEnd(int[][][] habitatGen, float fraction) {
  float seedLength = habitatGen.length * fraction;
  
  int seedEnd =  round( habitatGen.length / 2 + seedLength / 2 );
  if (seedEnd % 2 == 0) seedEnd++;
  seedEnd = min(seedEnd, habitatGen.length - 1);
  
  return seedEnd;
}
