void constructionCamera(Environment env) {
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
  mouseCamera(env, true);
}
