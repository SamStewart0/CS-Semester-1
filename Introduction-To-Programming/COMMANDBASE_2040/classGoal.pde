//class for command base/goal to be attacked by drones

class Goal {

  float x, y;
  float size;
  PImage turretGun, turretBase;
  float currentAngle;


  //CONSTRUCTOR FOR GOAL CLASS (COMMANDBASE)

  Goal() {
    this.x = (width/2);
    this.y = (height/1.15);
    size = (min(width, height))*0.15;
    turretGun = loadImage("turret0.png");
    turretBase = loadImage("turret1.png");
  }

  void display() {

    //SIZING AND OFFSET FOR BOTH TURRET PNGs
    float turretSizeGun = size*1.1;
    float turretSizeBase = size*1.2;
    // to offset bottom part of turret so the sprites line up correctly
    float turretBaseOffsetY = size * 0.225;

    imageMode(CENTER);
    //draw turret base
    image(turretBase, x, y+turretBaseOffsetY, turretSizeBase, turretSizeBase);

    //TURRET ROTATION

    //start new layer so rest of drawing isnt affected
    pushMatrix();


    //offset the centre so rotation is from back of turret
    float pivotOffset = -5;
    float yOffset = 10;

    //move origin/centre of rotation to the center of the turret
    translate(x, y + yOffset);

    //calculate angle for rotation between mouse and turret
    this.currentAngle = atan2(mouseY - y, mouseX - x);

    //rotate turret gun by the angle
    rotate(currentAngle);

    //rotate half_pi for correct angle rotation
    rotate(HALF_PI);
    //draw turret gun
    image(turretGun, 0, pivotOffset, turretSizeGun, turretSizeGun);

    //restore normal origin so rest of game isnt affected
    popMatrix();
  }
  //LOGIC FOR IF DRONE REACHES THE GOAL

  boolean goalReached(float droneX, float droneY, float droneSize) {

    //get distance between goal and enemy
    float dist = dist(x, y, droneX, droneY);

    //divide by 2 to get half width, stops early collision bug i was having
    //also add radius of drone so it isnt detecting the centre but edge
    if (dist<=(size/2)+(droneSize/2)) {
      return true;
    } else {
      return false;
    }
  }
}
