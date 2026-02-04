class Explosion {

  //VARIALE FOR EXPLOSION CLASS

  float x, y;
  float size;
  float lifespan;
  float lifespanEnd;

  //CONSTRUCTOR FOR EXPLOSION CLASS
  Explosion(float x, float y) {

    this.x = x;
    this.y = y;
    //VARIABLES FOR LIFESPAN OF EXPLOSION
    lifespan = 0;
    lifespanEnd = 20;
    size = 20;
  }
  void display() {
    //DISPLAYS EXPLOSION
    imageMode(CENTER);
    image(explosion, x, y, size, size);
  }
  boolean checkLifespan() {
    //CHECKS IF LIFESPAN HAS ENDED
    if (lifespan>lifespanEnd) {
      return true;
    } else {
      return false;
    }
  }
  void update() {
    //LIFESPAN COUNTER
    lifespan++;
    //RE DISPLAYS EXPLOSION
    display();
  }
}
