public static class RotationCoordinate {
  private PeasyCam cam;
  private CameraState defState;
  
  private CameraState zeroCam;
  private CameraState oneCam;
  private CameraState twoCam;
  
  public RotationCoordinate(PeasyCam cam) {
    this.cam = cam;
    
    Rotation defRot = new Rotation();
    Vector3D defCenter = new Vector3D();
    double defDist = 10;
    this.defState = new CameraState(defRot, defCenter, defDist);
    
    this.zeroCam = this.defState;
    this.oneCam = this.defState;
    this.twoCam = this.defState;
  }
  
  public CameraState getZeroCam() {
    print("here\nhere\nhere\nhere\nhere\nhere");
    if ((this.zeroCam).equals(this.defState)) {
      CameraState curr = this.cam.getState();
      cam.setRotations(0, PI, 0);
      this.zeroCam = cam.getState();
      cam.setState(curr);
    }
    
    return this.zeroCam;
  }
  
  public CameraState getOneCam() {
    if ((this.oneCam).equals(this.defState)) {
      print("here\nhere\nhere\nhere\nhere\nhere");
      CameraState curr = this.cam.getState();
      cam.setRotations(PI/2, 0, 0);
      this.zeroCam = cam.getState();
      cam.setState(curr);
    }
    
    return this.oneCam;
  }
  
  public CameraState getTwoCam() {
    print("here\nhere\nhere\nhere\nhere\nhere");
    if ((this.twoCam).equals(this.defState)) {
      CameraState curr = this.cam.getState();
      cam.setRotations(0, 3*PI/2, 0);
      this.zeroCam = cam.getState();
      cam.setState(curr);
    }
    
    return this.twoCam;
  }
}
