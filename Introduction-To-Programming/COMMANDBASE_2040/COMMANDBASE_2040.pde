
//GLOBAL VARIABLES
PImage gameBackground, menuBackground;
PImage startButton;
PImage drone0, drone1;
PImage speedDrone0, speedDrone1;
PImage explosion;

//GAME FONT
PFont font;
color fontColour = (#A5B7D6);

//DECLARE
IntList currentScore;

//SCORE
int score = 0;
int highScore = 0;

//LEVEL
int level = 1;

//GAME STATES
final int inGame = 0;
final int goalReached = 1;
final int menu = 2;
final int gameWon = 3;
int gameState =  inGame;

//BASE HEALTH
int health = 100;

//DRONE SPAWN MULTIPLIER
int droneMultiplier = 100;


//BULLET COUNT FOR ALTERNATE FIRING POSITION OF TURRET GUN
int bulletCount = 0;

//INSTANCE VARIABLES
Goal commandBase;
//array list as index and number of enemies changes constantly
ArrayList<Enemy> drones = new ArrayList<Enemy>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();

void setup() {


  //SET FRAME RATE TO STOP LAG
  frameRate(60);
  //SCREEN SIZE
  size(1000, 800);

  //this command removes outlines
  noStroke();

  //CREATE FONT AND COLOUR
  fill(fontColour, 350);
  font = createFont("BlackOpsOne-Regular.ttf", 32);
  textFont(font);



  //LOAD BACKGROUNDS AND RESIZE

  gameBackground = loadImage("bg.jpg");
  menuBackground= loadImage("menu.png");
  gameBackground.resize(width, height);
  menuBackground.resize(width, height);

  //LOAD IMAGES

  explosion = loadImage("explosion.png");

  drone0 = loadImage("drone0.PNG");
  drone1 = loadImage("drone1.PNG");

  speedDrone0 = loadImage("speedyDrone0.PNG");
  speedDrone1 = loadImage("speedyDrone1.PNG");

  startButton = loadImage("startButton.png");
  startButton.resize(width/2, height/5);


  //CREATE INITIAL INSTANCES

  commandBase = new Goal();
  generateDrones();//call drone generation function
}

void draw() {

  //LOOP FOR MENU
  if (gameState == menu) {



    //LOAD GAME MENU
    imageMode(CENTER);
    image(menuBackground, width/2, height/2);

    //LOAD BUTTON
    imageMode(CENTER);
    image(startButton, width/2, height/1.4);
  }

  //LOOP FOR IN GAME GAME STATE

  if (gameState == inGame) {

    //DRAW BACKGROUND AND COMMAND BASE AND HEALTH


    imageMode(CORNER);
    image(gameBackground, 0, 0);
    //call the command base method first as static
    commandBase.display();

    //DISPLAY HEALTH, SCORE AND LEVEL ON SCREEN

    textSize(15);
    //DISPLAY HEALTH AS RED If LOW

    if (health<20) {
      fill(#FF0000);
    }
    text("HEALTH: "+ health, width/25, height/20);

    //RESET TEXT COLOUR
    fill(fontColour);

    text("SCORE: "+score, width/25, height/10);
    text("LEVEL: "+level, width/1.1, height/20);

    //EXPLOSION LOGIC

    //ITERATE BACKWARDS THROUGH ALL OBJECTS IN ARRAY LIST
    for (int s = explosions.size() -1; s>=0; s--) {

      //UPDATE EXPLOSION

      Explosion currentExplosion = explosions.get(s);
      currentExplosion.update();

      //IF EXPLOSION LIFESPAN HAS ENDED REMOVE IT

      if (currentExplosion.checkLifespan()) {
        explosions.remove(s);
      }
    }

    //BULLET LOGIC


    //iterate through each bullet
    for (int i=bullets.size()-1; i>=0; i--) {

      Bullet currentBullet = bullets.get(i);


      //REMOVE BULLET IF OFF SCREEN
      if (currentBullet.x<0||currentBullet.x>width||
        currentBullet.y<0||currentBullet.y>height) {
        bullets.remove(i);
      }//update each bullet if not removed
      else {
        currentBullet.update();
      }
    }


    //THIS CODE HANDLES DRONE GENERATION TIMER

    if (frameCount%droneMultiplier == 0) {
      generateDrones();
    }

    //THIS CODE HANDLES DRONE MOVEMENT AND COLLISIONS

    //for loop to iterate backwards through array list
    //iterate backwards to avoid missing objects when removing or adding objects
    for (int i=drones.size() - 1; i>=0; i--) {

      //get the current drone from the list
      Enemy currentDrone = drones.get(i);
      //update current drone
      currentDrone.update(commandBase.x, commandBase.y, drones);

      if (currentDrone instanceof speedDrone) {
        //get the distance between mouse and speedDrone
        float dist = dist(mouseX, mouseY, currentDrone.x, currentDrone.y);

        //if it is less radius of drone
        if (dist <(currentDrone.size)) {
          //remove health
          health -= 1;
        }
      }

      //THIS LOGIC CHECKS FOR DRONE COLLISION WITH MISSILES AND REMOVES ACCORDINGLY

      for (int j=bullets.size() -1; j>=0; j--) {

        Bullet currentBullet = bullets.get(j);

        if (currentDrone.hit(currentBullet.x, currentBullet.y)) {
          //HANDLES SCORING LOGIC FOR DIFFERENT DRONES
          if (currentDrone instanceof speedDrone) {
            score += 20;
          } else {
            score+= 10;
          }
          //create an explosion if a drone has been hit
          explosions.add(new Explosion(currentDrone.x, currentDrone.y));


          //remove the drone and bullet that was hit
          drones.remove(i);
          bullets.remove(j);
          break;
        }
      }


      //DRONE COLLISION WITH BASE LOGIC

      //check if goal has been reached
      if (commandBase.goalReached(currentDrone.x, currentDrone.y, currentDrone.size) == true) {
        health -=10;
        drones.remove(i);
      }
      //end game if health is 0
      if (health <= 0) {
        //save high score called here
        saveHighScore();

        gameState = goalReached;
      }

      //SCREEN IF GAME WON
      if (health != 0 && frameCount == 15000 ) {
        saveHighScore();

        gameState = gameWon;
      }
    }
  }

  //goalReached GAME STATE CODE

  if (gameState == goalReached) {

    //DISPLAY SAME BG AS MENU
    imageMode(CENTER);
    image(menuBackground, width/2, height/2);
    textAlign(CENTER);
    textSize(60);
    text("GAME OVER", width/2, height/4);
    textSize(40);
    text("FINAL SCORE: " +score, width/2, height/2.5);
    text("HIGH SCORE: " +highScore, width/2, height/2);
  }
  if (gameState == gameWon) {
    //DISPLAY SAME BG AS MENU
    imageMode(CENTER);
    image(menuBackground, width/2, height/2);
    textAlign(CENTER);
    textSize(60);
    text("YOU WON!", width/2, height/4);
    textSize(40);
    text("FINAL SCORE: " +score, width/2, height/2.5);
    text("HIGH SCORE: " +highScore, width/2, height/2);
  }
}



void generateDrones() {

  //define start spawn amount for drones
  int numDrones = 5;
  int numSpeedDrones = 1;

  //IF STATEMENT FOR LEVEL AND DIFFICULTY HANDLING

  if (frameCount == 1000) {
    level++;
    numDrones = 10;
    numSpeedDrones = 3;
  }
  if (frameCount == 4000) {
    level++;
    numDrones = 15;
    numSpeedDrones = 6;
  }
  if (frameCount == 8000) {
    level++;
    numDrones = 20;
    numSpeedDrones = 10;
  }
  if (frameCount == 12000) {
    level++;
    numDrones = 25;
    numSpeedDrones = 14;
  }


  //NORMAL DRONE GENERATION

  for (int i=0; i<numDrones; i++) {
    //generate anywhere within x bounds
    float startX = random(width);
    //generate drones off screen so they can fly down
    float startY = random(-(height/4), -(height/10));

    //creates the instance of the class
    Drone newDrone = new Drone(startX, startY);
    //adds drone to array list
    drones.add(newDrone);
  }

  //SPEED DRONE GENERATION

  for (int j=0; j<numSpeedDrones; j++) {
    //generate anywhere within x bounds
    float speedStartX = random(width);
    //generate drones off screen so they can fly down
    float speedStartY = random(-(height/4), -(height/10));

    //creates the instance of the class
    speedDrone newspeedDrone = new speedDrone(speedStartX, speedStartY);
    //adds speedDrone to array list
    drones.add(newspeedDrone);
  }
}

void mousePressed() {
  if (gameState == menu) {

    //BUTTON PPRESS DETECTION

    float buttonX = width/2;
    float buttonY = height/1.4;

    //BUTTON HITBOX FOR STARTING GAME

    if (mousePressed) {

      if (mouseX > buttonX - (startButton.width / 2) &&
        mouseX < buttonX + (startButton.width / 2) &&
        mouseY > buttonY - (startButton.height / 2) &&
        mouseY < buttonY + (startButton.height / 2)) {
        gameState = inGame;
      }
    }
  }
  //LOGIC FOR FINDING BARREL TIP
  //DEFINE START VARIABLES
  float bulletStartY;
  float bulletStartX;
  //GET ACTUAL LENGTH AND WIDTH OF BARREL
  float barrelLength = min(width, height)/14;
  float barrelWidth = min(width, height)/60;
  //YOFFSET FOR CENTRE OF ROTATION FROM GOAL
  float yOffset = 10;

  //GET CURRENT ANGLE OF ROTATION FROM COMMAND BASE
  float spawnAngle = commandBase.currentAngle ;

  //CALCULATE FORWARD VECTOR FOR TIP FRONT
  //MULTIPLY BY BARREL LENGTH TO GET ACTUAL TIP X AND Y NOT 1 UNIT
  float barrelTipX = (commandBase.x ) +(barrelLength * cos(spawnAngle));
  //use yOffset here
  float barrelTipY = (commandBase.y + yOffset) +(barrelLength * sin(spawnAngle));

  //CALCULATE SIDEWAYS VECTOR TO PLACE MISSILE IN MIDDLE OF BARREL
  //MULTIPLY BY BARREL WIDTH TO GET ACTUAL X AND Y NOT 1 UNIT SIZE
  float sidewaysX = (-sin(spawnAngle))* barrelWidth;
  float sidewaysY = (cos(spawnAngle)) * barrelWidth;

  //LOGIC FOR ALTERNATE TURRET SHOOTING
  if (bulletCount % 2 == 0) {
    bulletStartX = barrelTipX + (sidewaysX);
    bulletStartY = barrelTipY + (sidewaysY);
  } else {
    bulletStartX = barrelTipX - (sidewaysX);
    bulletStartY = barrelTipY - (sidewaysY);
  }
  //create new bullet each mouse press
  Bullet newBullet = new Bullet(bulletStartX, bulletStartY, mouseX, mouseY);
  bullets.add(newBullet);
  bulletCount ++;
}

void saveHighScore() {


  //LOAD THE FILE
  String[] scores = loadStrings("highScore.txt");

  //CONVERT SCORE FROM STRING TO INT
  highScore = int(scores[0]);

  //CHECK IF WE BEAT THE HIGH SCORE
  if (score>highScore) {

    //SET HIGHSCORE TO CURRENT SCORE
    highScore = score;

    //CONVERT HIGHSCORE TO AN STR AND PUT IN AN ARRAY FOR STORAGE
    String[] scoreToStore = {str(highScore)};

    //SAVE THE DATA
    saveStrings("data/highScore.txt", scoreToStore);
  }
}
