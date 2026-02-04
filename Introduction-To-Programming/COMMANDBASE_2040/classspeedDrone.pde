class speedDrone extends Enemy {

  float speed;

  speedDrone(float x, float y) {


    super(x, y, 3);
  }

  void display() {
    imageMode(CENTER);//image mode center for correct click collision
    if ((frameCount/3)%2 == 0) {
      image(speedDrone0, x, y, size, size);//place drone image on drone
    } else {
      image(speedDrone1, x, y, size, size);
    }
  }
}
