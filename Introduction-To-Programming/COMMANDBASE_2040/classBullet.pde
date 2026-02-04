class Bullet {

  float x, y;
  float velocityX, velocityY;
  float barrelTipPosX, barrelTipPosY;
  float rotationAngle;
  PImage missile;
  float size;

  //CONSTRUCTOR FOR BULLET CLASS
  Bullet(float startX, float startY, float endX, float endY) {

    //DEFINE INITIAL VARIABLE
    missile = loadImage("missile.png");
    this.x = startX;
    this.y = startY;
    size = (min(width, height))*0.05;

    //BULLET VELOCITY MATHS

    float speed = 10;

    //CALCULATE TOTAL JOURNEY TAKEN ON X AND Y

    float distanceX = endX - startX;
    float distanceY = endY - startY;

    //FIND THE HYPOTANEUSE

    float totalDistance = sqrt((distanceX*distanceX)+(distanceY*distanceY));

    //NORMALISE THE DIRECTION VECTOR (DISTANCE ON X AND Y FOR 1 MOVEMENT)
    float directionX = distanceX/totalDistance;
    float directionY = distanceY/totalDistance;

    //MUTILPY VECTOR BY SPEED TO GET TOTAL MOVEMENT

    this.velocityX = directionX * speed;
    this.velocityY = directionY * speed;

    //CALCULATE ROTATION ANGLE
    //in constructor so this is only calculated once for each bullet
    this.rotationAngle  = atan2(this.velocityY, this.velocityX );
  }

  void display() {

    //DRAW BULLET WITH ROTATION

    //open new layer so rest of drawing is unaffected
    pushMatrix();

    //make current x,y the origin
    translate(this.x, this.y);

    //adjust angle for original angle of png
    rotate(this.rotationAngle+HALF_PI);

    //draw missile
    imageMode(CENTER);
    image(missile, 0, 0, size, size);

    //close layer
    popMatrix();
  }
  void update() {
    //update bullet x and y using the calculated velocity
    this.x  += this.velocityX;
    this.y  += this.velocityY;

    //then redraw
    display();
  }
}
