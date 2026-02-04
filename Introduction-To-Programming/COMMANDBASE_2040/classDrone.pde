class Drone extends Enemy {



  Drone(float x, float y) {

    super(x, y, 0.5);
  }

  void display() {
    imageMode(CENTER);//image mode center for correct click collision
    if ((frameCount/3)%2 == 0) {
      image(drone0, x, y, size, size);//place drone image on drone
    } else {
      image(drone1, x, y, size, size);
    }
  }
}
