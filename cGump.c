
// elementary cubic cell structure that knows about the boolean state of each
// of its faces.  intended to have its faces equivocated with those of other
// cells to form an automatic structure.
// intention:  front is positive X direction
//             right is positive Y direction
//             bottom is positive Z direction
struct Cell { bool *front, *back, *top, *bottom, *left, *right; };

// connects the 3D array of cells by equivocating faces of cells with
// with rectangular adjacency.  environment will not be toroidally connected.
void initRect(Cell ***env, , bool *subst, const unsigned int x, \
                                                 const unsigned int y, \
                                                 const unsigned int z)
{
  unsigned int idx = 0;
  for (unsigned int i = 0 ; i < x ; i++) {
    for (unsigned int j = 0 ; j < y ; j++) {
      for (unsigned int k = 0 ; k < z ; k++) {
        // connect backs of current planes with fronts of previous planes
        if (i != 0) env[i][j][k].back = env[i - 1][j][k].front = &subst[idx++];
        if (j != 0) env[i][j][k].left = env[i][j - 1][k].right = &subst[idx++];
        if (k != 0) env[i][j][k].top = env[i][j][k - 1].bottom = &subst[idx++];
      }
    }
  }
}

// main function for conducting tests
int main(int argc, char **argv) 
{
  // initialize, connect, and populate a 3x4x5 environment for tests
  unsigned int x = 3;
  unsigned int y = 4;
  unsigned int z = 5;
  // an xyz environment has (x+1)yz + (y+1)xz + (z+1)xy cells
  unsigned int size = (x + 1) * y * z +\
                           (y + 1) * x * z +\
                           (z + 1) * x * y;

  bool substance[size];
  for (unsigned int i = 0 ; i < size ; i++) substance[i] = false;
  Cell environment[x][y][z];
  
  initRect(environment, substance, x, y, z);

  
  return 0;
}
