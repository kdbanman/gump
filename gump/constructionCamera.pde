void constructionCamera(Environment env) {
  /*
    gui for constructing seeds.  only one plane is in focus at a time, mouse releases on cells toggle them. 
    camera properties:
      - always orthogonal to one of the plane sets.
      - left and right arrows control rotation for focus on particular plane sets.
      - up and down arrows control forward and back movement
        - maintain distance from plane in focus for consistency of mouse release locations
        - never get close enough for cutoff bug
    render properties:
      - focused planes are the only ones rendered without transparency
      - up and down arrows control focus on particular planes.
    
  */
  mouseCamera(env, true);
}
