#include <stdio.h>
#include <stdlib.h>

// elementary cubic cell structure that knows about the boolean state of each
// of its faces.  intended to have its faces equivocated with those of other
// cells to form an automatic structure.
// intention:  front is positive X direction
//             right is positive Y direction
//             top is positive Z direction
struct Cell { bool *front, *back, *left, *right, *top, *bottom; };

// connects the 3D array of cells by equivocating faces of cells with
// with rectangular adjacency.  environment will not be toroidally connected.
void initRect(Cell ***env, bool *subst, const unsigned int x, \
                                                 const unsigned int y, \
                                                 const unsigned int z)
{
  unsigned int idx = 0;
  for (unsigned int i = 0 ; i < x ; i++) {
    for (unsigned int j = 0 ; j < y ; j++) {
      for (unsigned int k = 0 ; k < z ; k++) {
        // define the unconnected back of the environment at i = 0
        if (i == 0) env[i][j][k].back = &subst[idx++];
        // define the unconnected front of the environment at i = x-1
        else if (i == x-1) env[i][j][k].front = &subst[idx++];
        // connect backs of current planes with fronts of previous planes
        else env[i][j][k].back = env[i - 1][j][k].front = &subst[idx++];

        // do the same patterns for the y and z directions of the environment
        if (j == 0) env[i][j][k].left = &subst[idx++];
        else if (j == y-1) env[i][j][k].right = &subst[idx++];
        else env[i][j][k].left = env[i][j - 1][k].right = &subst[idx++];
        
        if (k == 0) env[i][j][k].bottom = &subst[idx++];
        else if (k == z-1) env[i][j][k].top = &subst[idx++];
        else env[i][j][k].bottom = env[i][j][k - 1].top = &subst[idx++];
      }
    }
  }
}

// "pretty" printer for an environment
void pprint(Cell ***env)
{
  printf("shit goes here");
}

// main function for conducting tests
int main(int argc, char **argv) 
{
  // initialize, connect, and populate a 3x4x5 environment for tests
  unsigned int x;
  unsigned int y;
  unsigned int z;
  
  if (argc == 4) {
    x = atoi(argv[1]);
    y = atoi(argv[2]);
    z = atoi(argv[3]);
  } else {
    x = 3;
    y = 4;
    z = 5;
  }

  // an xyz environment has (x+1)yz + (y+1)xz + (z+1)xy cells
  unsigned int size = (x + 1) * y * z +\
                           (y + 1) * x * z +\
                           (z + 1) * x * y;

  bool substance[size];
  for (unsigned int i = 0 ; i < size ; i++) substance[i] = false;
  
  // if i initialize the pointer here, then relocate the allocation to a
  // function, does the memory only stay allocated within that function's 
  // scope?  what about deletion?  can that be put elsewhere?
  Cell ***environment;
  environment  = new Cell**[x];
  for (unsigned int i = 0 ; i < x ; i++) {
    environment[i] = new Cell*[y];
    for (unsigned int j = 0 ; j < y ; j++) {
      environment[i][j] = new Cell[z];
    }
  }

  initRect(environment, substance, x, y, z);
  
  pprint(environment);

  *environment[0][0][0].front = true;
  *environment[0][0][0].back = true;
  *environment[0][0][0].left = true;
  *environment[0][0][0].right = true;
  *environment[0][0][0].top = true;
  *environment[0][0][0].bottom = true;

  pprint(environment);

  *environment[1][0][0].back = false;
  *environment[0][1][0].left = false;
  *environment[0][0][1].bottom = false;

  pprint(environment);

  return 0;
}
