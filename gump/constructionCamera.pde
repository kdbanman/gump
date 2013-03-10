public static class ConstructionCamera {
  /*
    gui for constructing seeds.  only one plane is in focus at a time, mouse click on cells toggle them. 
    camera properties:
      - always orthogonal to one of the plane sets.
      - left and right arrows control rotation for focus on particular plane sets.
      - up and down arrows control forward and back movement
        - maintain distance from plane in focus for consistency of mouse click locations
        - never get close enough for cutoff bug
    render properties:
      - focused planes are the only ones rendered without transparency
      - up and down arrows control focus on particular planes.
    data controls:
      - mouse click on a cell toggles
      - mouse dragged across cells toggles 
      - 'c' clears entire seed
    
    IMPORTANT:  this function depends upon the system variable key
  */
  
  
  // Flag to indicate plane set currently being constructed, 0 => xy, 1 => xz, 2 => yz
  private static int planeSet;
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
    this.cam.setRotations(0, PI, 0);
    this.plane = minPlane;
    
    this.mouseXMin = (int) (0.266 * (float) windowW);
    this.mouseXMax = (int) ((1-0.266) * (float) windowW);
    this.mouseYMin = 0;
    this.mouseYMax = windowH;
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
      this.cam.setRotations(PI/2, 0, 0);
    } else if (this.planeSet == 1) {
      this.planeSet = 2;
      this.cam.setRotations(0, 3*PI/2, 0);
    } else {
      this.planeSet = 0;
      this.cam.setRotations(0, PI, 0);
    }
  }
  
  public void rotRight() {
    if (this.planeSet == 2) {
      this.planeSet = 1;
      this.cam.setRotations(PI/2, 0, 0);
    } else if (this.planeSet == 0) {
      this.planeSet = 2;
      this.cam.setRotations(0, 3*PI/2, 0);
    } else {
      this.planeSet = 0;
      this.cam.setRotations(0, PI, 0);
    }
  }
  
  public void mouseToggle(Environment env, int mX, int mY) {
    //TODO: currently have environment boundaries of environment cells per plane stored in
    // mouseXMax, etc.  there are 8 cells per linear dimension, so subtract the min from the mouse coord, divide by 8,
    // then mod the width of each cell (1.9cm by 1.9cm
  }
}
