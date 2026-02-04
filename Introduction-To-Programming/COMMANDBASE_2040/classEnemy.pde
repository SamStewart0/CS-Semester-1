//class for enemy/drones

abstract class Enemy {

  float x, y;
  float size;
  float speed;


  boolean destroyed = false;



  //CONSTRUCTOR FOR ENEMY CLASS
  Enemy(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    size = (min(width, height))*0.05;
    this.speed = speed;
  }
  void display() {
  }

  void move(float goalX, float goalY, ArrayList <Enemy> otherDrones) {
    //CHECKS FOR X MOVEMENT

    if (this.x < goalX ) {
      this.x = x+speed;//right movement
    } else if (this.x > goalX) {
      this.x = x-speed;//left movement
    }

    //CHECKS FOR Y MOVEMENT


    if (this.y < goalY ) {
      this.y = y+speed;//down movement
    } else if (this.y > goalY) {
      this.y = y-speed;//up movement
    }

    //CHECK IF NEAR OTHER DRONE AND MOVE AWAY IF CLOSE

    //ITERATE THROUGH EACH DRONE
    for (int i=0; i<otherDrones.size(); i++) {

      Enemy other = otherDrones.get(i);
      
      //GET DISTANCE BETWEEN THIS DRONE AND DRONE IN LIST

      float distance = dist(this.x, this.y, other.x, other.y);
      
      //DONT COMPARE WITH SELf

      if (other!=this) {
        
        //IF NORMAL DRONE AND 40 PIXELS OR IF SPEED DRONE AND 200 PIXELS (+ RADIUS)
        if (other instanceof Drone && distance<40+(other.size/2) ||
          other instanceof speedDrone && distance<200+(other.size/2)) {

          //IF THIS IS ON LEFT MOVE LEFT  

          if (this.x<other.x) {
            this.x -= speed;
          } 
          //ELSE MOVE RIGHT
          
          else {
            this.x += speed;
          }
        }
      }
    }
  }



  boolean hit(float bulletX, float bulletY) {

    //get the distance between drone and missile
    float dist = dist(bulletX, bulletY, this.x, this.y);
    //if it is less that the radius, its inside so true
    if (dist <(size/2)) {
      return true;
    } else {
      return false;
    }
  }
  //MOVE AND DISPLAY WRAPPED IN UPDATE METHOD
  void update(float goalX, float goalY, ArrayList <Enemy> otherDrones) {
    move(goalX, goalY, otherDrones);
    display();
  }
}
