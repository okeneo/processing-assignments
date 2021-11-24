/*
COMP 1010 A02
 INSTRUCTOR: DR. HEATHER MATHESON
 NAME: OGHENETEGA OKENE
 ASSIGNMENT: ASSIGNMENT 4
 Upto: 5
 
 PURPOSE: FOOD DROP GAME
 
 */

//global constants
final float PLANE_SPEED = 1.5;  //how many pixels we move the plane to the right per frame. Also the velocity of the plane (which is constant)
final float OUTSIDE_CANVAS = -84; //how far outisde the canvas we start and end at
final float GRAVITY = 0.02;  //gravitational constant for our game - different because our game counts 60 frames/second


//global variables
int theWidth;  //width of canvas
int theHeight;  //height of canvas
float distance;  //distance between buildings
float buildingWidth;  //how wide each building is
float windowWidth;  //width of window
float windowHeight;  //height of window
float horizonDistance; //distance of horizon from the ground
float buildingHeight;  //height of the building from the bottom of the canvas

float targetX = 0;  //the x coordinate of the target
float targetY = 0;  //the y coordinate of the target
float targetDiameter;  //diameter of the target

float planeWidth;  //width of plane
float planeHeight;  //height of plane
float planeX = OUTSIDE_CANVAS-planeWidth; //this is the xCord of the top corner of our rect/plane-----we have -80-30 = -110
float planeY = 35;  //this is the yCord of the top corner of our rect/plane
float wingWidth;  //width of wing of plane

float foodSize;  //the size of the food

int seconds = 0;  //number of frames passed since the start of the program
boolean pressedEnter = false;  //true if the user presses enter
float timeDropped = 0;  //time since the food was dropped from the plane

float initialX=0;  //the initial xCord of the food - set to the x position of the plane in the keyPressd function when a drop is allowed
float initialY=0;  //the initial yCord of the food - set to the y position of the plane in the keyPressd function when a drop is allowed
float initialVx=0;  //intial velocity of food - set to the speed of the plane in the keyPressd function

boolean isDropping = false ;  //true if we are allowed to make a new food drop

int score = 0;  //keeps track of how many times the user hits the target
int releaseCount = 0;  //counts to 60 so "food released" at key points in the frame are drawn for a short amount of time

boolean missedTarget = false;  //true if we are allowed to draw "miss!" on screen
boolean hitTarget = false;  //true if we are allowed to draw "target hit!" on screen
boolean releasedFood = false;  //true if we are allowed to draw "food released" on screen

int count = 0;  //counts to 60 so "miss" & "target hit!" at key points in the frame are drawn for a short amount of time
int shots = 0;  //number of food drops
int level = 1;  //number of levels in the game


void setup() {
  size(420, 420);
  theWidth = width;
  theHeight = height;

  //set dimensions for objects drawn on the canvas with respect to theWidth and theHeight
  buildingWidth = theWidth/20;
  distance = theWidth/28;  
  buildingHeight = theHeight/6;  
  horizonDistance = theHeight/14;  //the horizon height is made smaller than the building height so the horizon doesn't cover the building completely
  windowWidth = theWidth/84;
  windowHeight = theHeight/84;
  targetDiameter = horizonDistance;
  targetX = random(theWidth/2, theWidth-targetDiameter);
  targetY = theHeight-horizonDistance/2;
  planeWidth = theWidth/14;  //the width of the plane
  planeHeight = theHeight/42;  //the height of the plane
  wingWidth = theWidth/84;  //the width if the wings of the plane
  foodSize = theWidth/42;  //size of the food
}

void draw() {
  noStroke();  //no stroke looks better
  textSize(theWidth/21);  //set the textSize to a submultiple of the width of the canvas
  drawBackground();
  drawPermanentText();  //we want the plane drawn over the text
  drawPlane();
  seconds++;  //increments by 1 each frame to give us the number frames since the program began
  drawText();
  movePlane();  //put here so the food supply appears to come out of the plane
  drawTarget();

  if (isDropping) {  //if true we draw the food and do a lot of other things (see description of mainFunction())
    maninFunction();
  }
}



/*
this function draws the background of our game -
 The horizon and a building
 It also sets our background to black since it is night in our game
 */
void drawBackground() {
  background(50);  //set the background greyish for night time

  for (int x = 0; x<=theWidth; x+=buildingWidth+distance) {//we keep drawing a building till we get to the end of the canvas width
    //incrementing by the building width + distance between buildings
    drawBuilding(x, theHeight-buildingHeight);
  }

  //We draw the horizon last with colour green
  fill(20, 120, 10);
  rect(0, theHeight-horizonDistance, theWidth, theHeight-horizonDistance);
}

/*
This function takes in x and y 
 and draws a building with a window
 */
void drawBuilding(float x, float y) {
  fill(#A55B00);  //we want a brown building
  rect(x, y, buildingWidth, buildingHeight);  
  fill(#40EEFC);  //we want a blue window
  rect(x+buildingWidth/2, y+windowHeight, windowWidth, windowHeight);
}


/*
This function draws the target
 */
void drawTarget() {
  fill(200, 200, 0);  //make target yellow
  circle(targetX, targetY, targetDiameter);
}


/*
This function draws the plane
 */
void drawPlane() {
  fill(255);  //we draw a white plane that starts outside the canvas
  rect(planeX, planeY, planeWidth, planeHeight);

  //The wings and the tip of the plane depend on planeX,wingWidth and planeHeight 
  triangle(planeX+planeWidth, planeY, (planeX+planeWidth)-wingWidth, planeY+planeHeight, (planeX+planeWidth)+wingWidth, planeY+planeHeight);
  rect(planeX+(planeWidth/2), planeY-wingWidth, wingWidth, wingWidth+planeHeight+wingWidth);
}

/*
This function moves the plane by PLANE_SPEED
 */
void movePlane() {
  planeX += PLANE_SPEED;  //move plane by PLANE_SPEED each frame
  if (planeX>=theWidth-(OUTSIDE_CANVAS)) {  //if the plane is width plus a distance out of the canvas...
    planeX = OUTSIDE_CANVAS-planeWidth;  //then we make the plane go back to it's starting position on the left side of the canvas
  }
}

/*
This function draws all the texts
 that will be on the background
 of the canvas at all times
 */
void drawPermanentText() {
  textSize(theWidth/21);
  fill(200, 200, 0);  //make texts yellow
  //we space out the texts on the canvas so that they are close to the same distance apart on the y axis
  text("Level: " + level, theWidth-(theWidth/4), (theHeight/7.5));  //draw the level at all times
  text("Shots: " + shots, theWidth-(theWidth/4), (theHeight/5.2));  //draw the shots taken at all times
  text("Hits: " + score, theWidth-(theWidth/4), (theHeight/4));  //draw the number of successful hits at all times
}





/*
This function calculates the time since the food was dropped
 */
float calcTimeSinceDropped(float time) {
  time = seconds;
  float timeSinceDrooped;
  timeSinceDrooped = time-timeDropped;
  return timeSinceDrooped;
}


/*
This function calculates the x coord of the food
 at the given time t , initial x postion and intial velocity.
 */
float calcFoodX(float flightTime, float intX, float initV) {
  float x;
  x = intX + (initV*flightTime);  //calculates x position of the food at each time
  return x;
}

/*
This function calculates the y coord of the food
 at the given time t and initial x postion.
 */
float calcFoodY(float flightTime, float intY) {
  float y;
  y = intY + (0.5*GRAVITY*(sq(flightTime)));  //calculates y position of the food
  return y;
}


/*
Runs once.
 The only key that will affect our program is "enter".
 */
void keyPressed() {

  pressedEnter = key == ENTER;  //if user presses "enter"
  if (!isDropping) {  //if isDropping is true we are NOT allowed to start a new drop
    if (pressedEnter) {  //if isDropping is false and the user presses enter then we can start a new drop
      timeDropped = seconds;  //set timeDropped to the time the drop started
      initialX = planeX;  //set the x position of the food to the x Position of the plane at the time the food was dropped
      initialY = planeY;  //set the y position of the food to the y Position of the plane at the time the food was dropped
      initialVx = PLANE_SPEED;  //set the initial velocity of the food to the velocity of the plane (the velocity of the plane is constant)
      isDropping = true;  //We set isDropping to true to prevent a second food drop
      //and also, so that we can start moving the food 
      shots++;  //we want to increment shots by 1 (once) if we are allowed a drop
    }
  }
}




/*
if (isDropping) this function does the following:
 -draws the food given the current position of the food & the food positions on screen
 -does tasks if we hit the target
 -adds levels to the game
 -calls the belowGround and outOfView functions
 -and does tasks if we miss i.e. belowGround or outOfView is true
 ___________________________________
 */
void maninFunction() {
  float t = calcTimeSinceDropped(seconds);  //calculate the time since the drop started
  float foodX = calcFoodX( t, initialX, initialVx);  //find the x position of the food at each given time
  float foodY = calcFoodY( t, initialY);  //find the y position of the food at each given time
  fill(200, 20, 20);  //reddish food
  circle(foodX, foodY, foodSize);  //circular food

  textSize(theWidth/21);
  text("Food X: "+ int(foodX), theWidth/21, theHeight/10.5);  //print the xCord on the screen
  text("Food Y: "+ int(foodY), theWidth/21, theHeight/6);  //print the yCord on the screen

  releasedFood = true;  //set to true so we draw "food released" on screen
  if (releasedFood) {  //if we are able to draw food released on screen then....
    hitTarget = false;  //we are not allowed to draw "target hit!" on the screen
    missedTarget = false;  ////we are not allowed to draw "miss!" on the screen
  }

  boolean hit = foodInObject(targetX, targetY, targetDiameter, foodX, foodY);

  //if we hit the target then....
  //setting isDropping to false means that we can add a new food drop
  if (hit) {
    score +=1;  //add 1 to score
    isDropping = false;  //we are not allowed to make a new drop
    hitTarget = true;  //we draw "target hit!" on the screen
    missedTarget = false;  //we are not allowed to draw "miss!" on the screen
    releasedFood = false;  //we are not allowed to draw "food released" on the screen
    count = 0;  //we set count to 0 so that in our drawText() function we can start a fresh count up to 60
    releaseCount = 0;  //we set releasecount to 0 so that in our drawText() function we can start a fresh count up to 60

    /*
      We add levels
     */
    if (score%3==0) {  //if we get three hits and we are <= 10 levels...
      level++;  //we update levels
      targetX = random(theWidth/2, theWidth-targetDiameter);  //set a new x postion for the target
      if (level<10) {
        targetDiameter = targetDiameter-2;  //reduce the diameter of the target by two
      }
    }
  }

  //We call a function to test if we are below the ground
  boolean belowGround = belowGround(foodY);
  if (belowGround) {
  } 
  //We call a function to test if we are out of view along the x axis
  boolean outOfView = outOfView(foodX);
  if (outOfView) {
  }

  //if either of these situation are true then ....
  if (belowGround||outOfView) {
    isDropping = false;  //we are not allowed to make a new drop
    missedTarget = true;  //this must mean that we missed the target and we can draw "miss!" on screen
    releasedFood = false;  //we are not allowed to draw "food released" on the screen
    hitTarget = false;  //we are not allowed to draw "target hit!" on the screen
    count = 0;  //we set count to 0 so that in our drawText() function we can start a fresh count up to 60
    releaseCount = 0;  //we set releasecount to 0 so that in our drawText() function we can start a fresh count up to 60
  }
}



/*
This function draws texts at key points in our program.
 Namely missed shot,target hit and food released.
 We have three different scenarios and 
 we draw the text in the middle of the canvas
 */
void drawText() {
  textSize(theWidth/15);
  String missedText = "MISS!";  //indicates a shot was missed
  String hitText = "TARGET HIT!";  //indicates the target was hit
  String releasedText = "FOOD RELEASED";  //indicates the food was released

  if (missedTarget&&count<=60) {  //if we missed the shot and count less than 60, draw "miss!" on canvas
    text(missedText, theWidth/2-(textWidth(missedText)/2), theHeight/2-(textAscent()));
    count++;
  } else if (releasedFood&&releaseCount<=60) {  //if we released the food and releasecount less than 60, draw "food released" on canvas
    text(releasedText, theWidth/2-(textWidth(releasedText)/2), theHeight/2-(textAscent()));
    releaseCount++;
  } else if (hitTarget&&count<=60) {  //if we hit the target and count less than 60, draw "target hit!" on canvas
    text(hitText, theWidth/2-(textWidth(hitText)/2), theHeight/2-(textAscent()));
    count++;
  }
}



/*
This function tests if the food's y coordinate
 is below ground level i.e. off the bottom of the canvas
 indicating that the target was missed
 */
boolean belowGround(float y) {
  if (y>theHeight) {
    return true;
  } else {
    return false;
  }
}

/*
This function tests if the food's x coordinate
 is out of view and
 also indicating that the target was missed
 */
boolean outOfView(float x) {
  if (x>theWidth) {
    return true;
  } else {
    return false;
  }
}



/*
This function tests if the 
 food's position is within a
 circular object
 */
boolean foodInObject(float objectX, float objectY, float objectDiameter, float foodX, float foodY) {
  //tests if the food is within the target in the x direction
  boolean withinObjectX = (foodX>(objectX-objectDiameter/2))&&((foodX<(objectX+objectDiameter/2)));
  //tests if the food is within the target in the y direction
  boolean withinObjectY = (foodY>(objectY-objectDiameter/2))&&((foodY<(objectY+objectDiameter/2)));

  if (withinObjectX&&withinObjectY) {
    return true;  //returns true if both statements are true
  } else {
    return false;  //otherwise return false
  }
}
