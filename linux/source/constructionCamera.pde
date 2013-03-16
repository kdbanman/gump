public static class ConstructionCamera {
  /*
    gui for constructing seeds.  only one plane is in focus at a time, mouse click on cells toggle them. 
   camera properties:
   - always orthogonal to one of the plane sets.
   - left and right arrows control rotation for focus on particular plane sets.
   - up and down arrows control forward and back movement
   render properties:
   - focused planes are the only ones rendered without transparency
   - up and down arrows control focus on particular planes.
   data controls:
   - mouse click on a cell toggles it
   - numerical values (designed for number keys) give a full seed
     roughly corresponding in size to the value of the key
   
   */


  // Flag to indicate plane set currently being constructed, 0 => xy, 1 => xz, 2 => yz
  private static int planeSet;
  // Rotation targets for switching between planesets smoothly
  private static RotationCoordinate rotTargets;
  // Plane number within plane set currently being constructed
  //   can only be odd
  //   must be in interval centered in evronment ~38% its length (denoted by minPlane, maxPlane)
  private static int plane;
  private static int minPlane;
  private static int maxPlane;
  // Environment/camera UI will be manipulating
  private static Environment environ;
  private static PeasyCam cam;
  // Need to replace cam.getDistance() in places for rapid successive .forward() or .back() calls
  private static double camDist;
  // pixel boundaries where the environment occupies (based on 1080:720 ratio), Y boundaries are 0 and height, trivially
  private static int mouseXMin;
  private static int mouseXMax;
  private static int mouseYMin;
  private static int mouseYMax;
  // pixel dimension of each cell when in focussed plane
  private static int cellDim;

  public ConstructionCamera(Environment env, float fraction, PeasyCam cam, int windowW, int windowH) {
    this.environ = env;
    this.cam = cam;

    double middle = ((double) this.environ.dimSize) / 2 * 10 + 10;
    this.camDist = middle - 14;
    this.cam.setDistance(this.camDist);
    this.cam.lookAt(middle, middle, middle);
    this.cam.setMinimumDistance(0.01);
    this.cam.setMaximumDistance(middle*2);
    this.cam.setSuppressRollRotationMode();
    this.cam.setActive(false);

    this.minPlane = env.getSeedStart(fraction);
    this.maxPlane = env.getSeedEnd(fraction);

    // initial focus on first seed plane of plane set xy
    this.planeSet = 0;
    this.rotTargets = new RotationCoordinate(middle);
    this.cam.setRotations(0, PI, 0);
    
    this.plane = minPlane;

    this.mouseXMin = (int) (0.162 * (float) windowW);
    this.mouseXMax = (int) ((1-0.162) * (float) windowW);
    this.mouseYMin = 0;
    this.mouseYMax = windowH;

    this.cellDim = (this.mouseXMax - this.mouseXMin) / 9;
  }

  public void forward() {
    if (this.plane < this.maxPlane) {
      this.plane += 2;
      this.camDist -=20;
      this.cam.setDistance(this.camDist);
    }
  }

  public void backward() {
    if (this.plane > this.minPlane) {
      this.plane -= 2;
      this.camDist += 20;
      this.cam.setDistance(this.camDist);
    }
  }

  public void rotLeft() {
    if (this.planeSet == 0) {
      this.planeSet = 1;
      this.cam.setState(this.rotTargets.getOneCam(this.camDist));
    } else if (this.planeSet == 1) {
      this.planeSet = 2;
      this.cam.setState(this.rotTargets.getTwoCam(this.camDist));
    } else {
      this.planeSet = 0;
      this.cam.setState(this.rotTargets.getZeroCam(this.camDist));
    }
  }

  public void rotRight() {
    if (this.planeSet == 2) {
      this.planeSet = 1;
      this.cam.setState(this.rotTargets.getOneCam(this.camDist));
    } 
    else if (this.planeSet == 0) {
      this.planeSet = 2;
      this.cam.setState(this.rotTargets.getTwoCam(this.camDist));
    } 
    else {
      this.planeSet = 0;
      this.cam.setState(this.rotTargets.getZeroCam(this.camDist));
    }
  }

  public void mouseToggle(int mX, int mY) {
    // rendered pixel boundaries of environment cells for the in-focus plane are stored in mouseXMax, mouseYMax,
    // mouseXMin, mouseYMin.
    // there are 9 cells per linear dimension, so subtract the min from the mouse coord, divide by 9, and
    // then mod the width of each cell (84 pixels)
    if (mX <= mouseXMax && mX >= mouseXMin && mY <= mouseYMax && mY >= mouseYMin) {
      int clickX = 2 * ((mX - this.mouseXMin) / cellDim);
      int clickY = 2 * ((mY - this.mouseYMin) / cellDim);

      int xCoord = this.minPlane + 1;
      int yCoord = this.minPlane + 1;
      int zCoord = this.minPlane + 1;

      if (this.planeSet == 0) {
        xCoord -= clickX - this.maxPlane + this.minPlane + 2;
        yCoord += clickY;
        zCoord = this.plane;
      } 
      else if (this.planeSet == 1) {
        xCoord += clickX;
        yCoord = this.plane;
        zCoord += clickY;
      } 
      else {
        xCoord = this.plane;
        yCoord += clickY;
        zCoord += clickX;
      }

      this.environ.habitat[xCoord][yCoord][zCoord] = !this.environ.habitat[xCoord][yCoord][zCoord];
    }
  }

  public void generateFull(int seedSize) {
    // populate habitat with full cube of on cells of size seedSize

      for (int x = this.minPlane; x <= maxPlane; x++) {
      for (int y = this.minPlane; y <= maxPlane; y++) {
        for (int z = this.minPlane; z <= maxPlane; z++) {
          if (x%2 + y%2 + z%2 == 1) {
            this.environ.habitat[x][y][z] = false;
          }
        }
      }
    }

    int seedStart = this.environ.dimSize / 2 - seedSize / 2;
    int seedEnd = seedStart + seedSize;

    for (int x = seedStart ; x <= seedEnd ; x++) {
      for (int y = seedStart ; y <= seedEnd ; y++) {
        for (int z = seedStart ; z <= seedEnd ; z++) {
          if (x%2 + y%2 + z%2 == 1) {
            this.environ.habitat[x][y][z] = true;
          }
        }
      }
    }
  }
}

