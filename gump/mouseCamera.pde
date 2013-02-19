void mouseCamera(int renderMode) {

  if (renderMode == 1) {
    float cameraY = height/0.5;
    float fov = mouseY/float(width) * PI/2;
    float cameraZ = cameraY / tan(fov / 2.0);
    float aspect = float(width)/float(height);
    perspective(fov, aspect, cameraZ/10.0, cameraZ*10.0);

    translate(width/2, height/2, 0);
    rotateX(-PI/6);
    rotateY(PI/3 + mouseX/float(height) * PI);
  }
}

