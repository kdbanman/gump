boolean toroidal(boolean[][][] habitatTor, int x, int y, int z) {

  //if the array indices called are out of bounds by integer > 0, return their toroidal counterparts
  int xTrans = (x < 0) ? (habitatTor.length + x) : ( (x >= habitatTor.length)?(x - habitatTor.length):x );
  int yTrans = (y < 0) ? (habitatTor.length + y) : ( (y >= habitatTor.length)?(y - habitatTor.length):y );
  int zTrans = (z < 0) ? (habitatTor.length + z) : ( (z >= habitatTor.length)?(z - habitatTor.length):z );

  return habitatTor[xTrans][yTrans][zTrans];
}
