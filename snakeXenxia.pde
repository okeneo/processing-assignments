/*
COMP 1010 A02
 INSTRUCTOR: DR. HEATHER MATHESON
 NAME: OGHENETEGA OKENE
 ASSIGNMENT: ASSIGNMENT 5
 
 Upto: 6
 
 PURPOSE: THE SNAKE GAME
 
 */
 
 

//global constants
final int ROWS=20, COLS=15; //The number of rows and columns of squares
final int SQ_SIZE=40;       //The size of each square in pixels
final int [] X_DIRECTIONS = {0, -1, 0, +1};  //an array that indictates movement in the x direction
final int [] Y_DIRECTIONS = {+1, 0, -1, 0};  //an array that indictates movement in the y direction

final int APPLE_INC_RATE = 3;  //how fast the apples will increase for each new level
final int START_LENGTH_INC = 1;  //how much we will increase the starting length by each time we level up
final int SPEED_DEC = 3; //how much we decrease the time needed till the next movement of the snake (each time we level up)
final int SNAKE_GROWTH_STEP = 1; //how much we want the snake to grow each time we level up

//global variables
int[] xArray = new int [COLS*ROWS];  //an array large enough to fit the entire canvas
int[] yArray = new int [ROWS*COLS];  //an array large enough to fit the entire canvas
int size = 0;  //current filled size of array ---- current length of the snake (i.e. we will fill the x and y cord arrays with 'size' amount of values each and 'size' number of circles
int startingLength = 5;  //controls the length of the snake at the start of each level --- i.e. 5 circles at first

int[] appleArrayX = new int [COLS*ROWS];  //an array to store the x positions of the apples --- up to every single grid
int[] appleArrayY = new int [ROWS*COLS];  //an array to store the y positions of the apples --- up to every single grid
int current = 0;  //current number of apples we have on screen --- this can change
int startingApples = 5;  //we start with 5 apples on screen

int seconds = 0;  //how many times the draw function has been run since the start of our program. The "seconds" for our game

int moveX = 0;  //the values for our moveSnake function
int moveY = 0;  //the values for our moveSnake function

int snakeDir = 0;  //indicates current snake direction

int snakeGrowthRate = 3;  //how much the snake will grow after eating an apple. This will increase as we level up but we start at 3

int numNewCircles = 0;  //number of circles we need to draw after the snake eats an apple

int movePerSecond = 30;  //how much we want to move the snake per second

int numApples = 0;  //saves the number starting apples we have for each level and will increase by APPLE_INC_RATE each new level



void setup() {
  background(125);
  size(600, 800); //MUST be COLS*SQ_SIZE,ROWS*SQ_SIZE
  resetSnake();  //start snake in the middle of the canvas with only the head visible
  current = startingApples;  //set the current number of apples to 'startingApples'
  numApples = startingApples;  //set the number of apples which will be saved in each level to the starting number of apples
  resetApples(current);  //fill an array with values for our starting apples
}//setup



void draw() {
  background(125);

  seconds++;  //number of seconds since the game began

  moveX = X_DIRECTIONS[snakeDir];  //set moveX to index 'snakeDir' in the array X_DIRECTIONS each time we press any of the keys that make the snake move
  moveY = Y_DIRECTIONS[snakeDir];  //set moveY to index 'snakeDir' in the array Y_DIRECTIONS each time we press any of the keys that make the snake move

  boolean gameOver = detectCrash();  //test every frame if the snake has bitten itself or gone out of the canvas

  if (!gameOver) {  //if false, keep moving the snake, if true we stop moving the snake and everthing stops

    if (seconds%movePerSecond==0) {  //move the snake every 30 frames to start. This will reduce as we level up
      moveSnake(moveX, moveY);  //call the moveSnake function to move the snake

      if (numNewCircles>0) {  //if we have a circle to draw
        size+=1;  //increase the size of our snake by 1 each time we move but up to a count of 'snakeGrowthRate' per apple
        numNewCircles--;  //now we have to draw 1 less snake
      }

      appleEatenTest();
    }
  }

  if (current==0) {  //if the snake has eaten all the apples on the screen, we level up
    newLevel();
  }

  drawCircles(xArray, yArray, size, #FFFF00);  //draw the circles
  drawCircles(appleArrayX, appleArrayY, current, #F26464); //draw apples

  if (gameOver) {  //if the game is over, print "Gameover!" on the canvas
    printGameOver();
  }
}//draw



/*
this function tests if the snake has eaten an apple and
 then calls the function that deletes the apple at that index
 */
void appleEatenTest() {
  int test = searchArrays(appleArrayX, appleArrayY, current, 0, xArray[0], yArray[0]);  //test if the snake eats an apple each time the snake moves
  if (test!=-1) {  //if the index of the head of the snake and an apple are the same for both the x and y positions
    deleteApple(test);  //delete the apple at that index and move up the other positions
    numNewCircles += snakeGrowthRate;  //if the snake eats an apple, we want to add 3 circles to the number of snakes we need to draw
  }
}


/*
starts a new level and make the game harder
 when the last apple in each level has been eaten
 */
void newLevel() {
  startingLength += START_LENGTH_INC;  //we increase the starting length by 'START_LENGTH_INC' each time we level up. START_LENGTH_INC is set to 1
  resetSnake();  //reset the snake to the top of the canvas
  snakeDir = 0;  //set the snakeDir to 0 so that the snake moves downwards 
  numApples += APPLE_INC_RATE;  //saves the number of starting apples for each level and it is increased by 'APPLE_INC_RATE' each time we level up
  current = numApples;  //set current to the new incremented number of apples
  resetApples(current);  //draw a new set of apples
  numNewCircles = 0;  //we dont need to draw anymore "new" circles after eating an apple so we reset that
  movePerSecond -= SPEED_DEC;  //we increase the speed of the snake by reducing the number of seconds till we can move the snake again
  snakeGrowthRate+= SNAKE_GROWTH_STEP;  //the snake will grow longer by 1 each new level
}



/*
will return true if the snake bites itself or the snake leaves the canvas
 and the game will end.
 */
boolean detectCrash() {
  boolean boolTest = false;  //indictaes if the game is over

  //Snake leaves the canvas
  if (xArray[0]==-1||xArray[0]==COLS) {  //if the snake head goes past the canvas on the x axis
    boolTest = true;
  }
  if (yArray[0]==-1||yArray[0]==ROWS) {  //if the snake head goes past the canvas on the y axis
    boolTest = true;
  }

  //Snake eats itself
  int sameIndex = searchArrays(xArray, yArray, size, 1, xArray[0], yArray[0]);  //test if the head of the snake and any other circles of the snake have the same index
  //we start our search at 1, because we want the cases where the head of the snake is equal to a body part (but we don't want to search the array for the snake head itself i.e. at index 0
  if (sameIndex!=-1) {  //if we have a valid index, then we found a position where the snake head and one of its other parts are the same
    boolTest = true;
  }

  return boolTest;  //return true if we have detetected a crash and return false otherwise
}



/* printGameOver
 Print a game over message on the canvas.
 */
void printGameOver() {
  textSize(height/10);
  fill(0);
  String message = "GAME OVER!";
  text(message, (width-textWidth(message))/2, (height+textAscent()-textDescent())/2);
}



/*
will try to find a pair of coordinates
 (x[i],y[i]) in the first n elements of the arrays x and y
 that  are  equal  to  (keyX, keyY) and starting at 'start'
 */
int searchArrays(int[]x, int[]y, int n, int start, int keyX, int keyY) {
  for (int i = start; i<n; i++) {  //start search at 'start', till we get to the first n elements of the arrays x and y, increment by 1
    if (x[i]==keyX&&y[i]==keyY) {  //if we found equality in both the y and x positions then we
      return i;  //return the index and end the search immediately
    }
  }
  return -1;  //if we finish the search and we did not find it we return an impossible index
}


/*
will delete the apple at the given index (where 'eatenApple' is the index)
 from the list of the apples, reducing the number of apples by 1.
 */
void deleteApple(int eatenApple) {
  for (int i=eatenApple; i<current-1; i++) {
    appleArrayX[i] = appleArrayX[i+1];  //move all the other apples in the array accordingly
    appleArrayY[i] = appleArrayY[i+1];  //move all the other apples in the array accordingly
  }
  appleArrayX[current-1] = 0;  //make the array smaller
  appleArrayY[current-1] = 0;  //make the arryay smaller
  current--;  //reduce the current size of the array
}


/*
fills the first n elements of the array 'a' with data.
 The first element set to start and each new element after that
 should differ from the previous one by delta
 */
void fillArray(int[]a, int n, int start, int delta) {
  a[0] = start;  //set the first value to start

  for (int i = 1; i<n; i++) {
    a[i] = a[i-1]+delta;  //and increment adding 'delta' to the previous array to give us the value for the current array
  }
}


/*
Draws n circles in the canvas at the positions (x[i],y[i])
 specidfied by the first n elements of the x and y arrays
 and the specified colour.
 */
void drawCircles(int[]x, int[]y, int n, int colour) {
  float [] arrayX = new float [n];  //an array that stores each x value in pixels
  float [] arrayY = new float [n];  //an array that stores each y value in pixels

  fill(colour);
  for (int i=0; i<arrayX.length; i++) {
    //convert from grid to pixels
    arrayX[i] = (x[i]*SQ_SIZE)+SQ_SIZE/2;  //the formula for each position is e.g. for position 0 is (0*40)+20 = 20 & position 1 is (1*40)+20 = 60 
    arrayY[i] = (y[i]*SQ_SIZE)+SQ_SIZE/2;  //the formula for each position is e.g. for position 0 is (0*40)+20 = 20 & position 1 is (1*40)+20 = 60 
    circle(arrayX[i], arrayY[i], SQ_SIZE);  //draw a circle for each position.
  }
}

/*
Will set the current length(size) of the snake to the starting length,
 and create a snake of that length with it's head in the centre of the top row,
 */
void resetSnake() {
  size = startingLength;  //set the current length to the starting length
  fillArray(xArray, size, COLS/2, 0);  //fill the x array starting at the middle of the canvas. the first element is set to COLS/2 = 7 and each elemnt differs after that one by 0
  fillArray(yArray, size, 0, -1);  //fill the y array starting at the top of the canvas. the first element is set to 0 and each elemnt differs after that one by -1
  drawCircles(xArray, yArray, size, #FFFF00);  //draw the circles
}


/*
This function moves the sanke given addX and addY
 This is done by iterating through the snake arrays 
 and modifying the bins
 */
void moveSnake(int addX, int addY) {

  for (int i=size; i>0; i--) {  //iterating starting at the element at index 'size'
    yArray[i] = yArray[i-1];  //move down elements except the element at index 0
  }
  yArray[0] = yArray[0] + addY;  //add addY to the first element(the head)


  for (int i=size; i>0; i--) { //iterating starting at the element at index 'size'
    xArray[i]= xArray[i-1];  //move down elements except the element at index 0
  }
  xArray[0] += addX;  //add addX to the first element(the head)
}


/*
will create and return an array of
 exactly n int values,randomly chosen from the values 0 to max
 */
int[] randomArray(int n, int max) {
  int[] randArray = new int [n];  //create new array to store the values of our new randome numbers

  for (int i=0; i<randArray.length; i++) {
    randArray[i] = int(random(max));  //add a random number from 0 to max-1 into each bin of our new array.
  }
  return randArray;  //return the new random array
}


/*
will use randomArray() to pick a random set
 of 'startingApples' apples
 */
void resetApples(int numApples) {
  int x [] = randomArray(numApples, COLS);  //we want 5 apples at grid positions 0 to COLS-1 to start
  int y [] = randomArray(numApples, ROWS);  //we want 5 apples at y positions 0 to ROWS-1 to start

  for (int i = 0; i<current; i++) {
    appleArrayX[i] = x[i];  //copy each element from the x array to appleArrayX
    appleArrayY[i] = y[i];  //copy each element from the y array to appleArrayY
  }
}



/*
we use keyPressed to control the motion of the snake
 if the user clicks a,d,l,k (ignoring cases),
 we update our snake positions so we can move the snake accordingly
 */
void keyPressed() {
  //if any of these are true, the snake will turn clockwise
  boolean pressedL = key == 'L';
  boolean pressedl = key == 'l';
  boolean pressedD = key == 'D';
  boolean pressedd = key == 'd';

  //if any of these are true, the snake will turn anti-clockwise
  boolean pressedA = key == 'A';
  boolean presseda = key == 'a';
  boolean pressedJ = key == 'J';
  boolean pressedj = key == 'j';


  if (pressedd||pressedD||pressedL||pressedl) {
    snakeDir = (snakeDir + 1)%4;  //we want values 0 to 3 inclusive for our snakeDir and we will increment because of the values in our X_DIRECTION & Y_DIRECTOIN arrays.
  }

  if (presseda||pressedA||pressedj||pressedJ) {
    if (snakeDir==0) {  //if the snake is going down
      snakeDir = 3;  //and the user enters a or j, we set snakeDir = 3 and then move counter-clockwise
    } else {
      snakeDir = (snakeDir-1)%4;  //we want values 0 to 3 inclusive and we will decrement because of the values in our X_DIRECTION & Y_DIRECTOIN arrays. We want values 3210 for the most part
    }
  }
}
