public static class RotationCoordinate {
  private Rotation zeroRot;
  private Rotation oneRot;
  private Rotation twoRot;
  
  private Vector3D lookAt;
  
  private CameraState zeroCam;
  private CameraState oneCam;
  private CameraState twoCam;
  
  public RotationCoordinate(double middle) {
    lookAt = new Vector3D(middle, middle, middle);
    
    zeroRot = new Rotation(RotationOrder.XYZ, 0, PI, 0);
    oneRot = new Rotation(RotationOrder.XYZ, PI/2, 0, 0);
    twoRot = new Rotation(RotationOrder.XYZ, 0, 3*PI/2, 0);
  }
  
  public CameraState getZeroCam(double distance) {
    return new CameraState(this.zeroRot, this.lookAt, distance);
  }
  
  public CameraState getOneCam(double distance) {
    return new CameraState(this.oneRot, this.lookAt, distance);
  }
  
  public CameraState getTwoCam(double distance) {
    return new CameraState(this.twoRot, this.lookAt, distance);
  }
}
