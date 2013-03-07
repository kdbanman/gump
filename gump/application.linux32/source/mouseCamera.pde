void mouseCamera(Environment env, boolean emptyCells) 
{
  /*
    camera that reacts to mouse movement, for when the environment is evolving
  */
  float cameraY = height/0.5;
  float fov = mouseY/float(width) * PI/2;
  float cameraZ = cameraY / tan(fov / 2.0);
  float aspect = float(width)/float(height);
  perspective(fov, aspect, cameraZ/50.0, cameraZ);

  translate(width/2, height/2, 0);
  rotateX(-PI/6);
  rotateY(PI/3 + mouseX/float(height) * PI);
  
  render(env, emptyCells);
}
