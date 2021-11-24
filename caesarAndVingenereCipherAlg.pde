/*
COMP 1010 A02
 INSTRUCTOR: DR. HEATHER MATHESON
 NAME: OGHENETEGA OKENE
 ASSIGNMENT: ASSIGNMENT 3
 Upto: 6
 
 PURPOSE: Cryptography - Caesar and Vigenere cipher algorithm
 
 */

import javax.swing.JOptionPane;

String encryptedText = "";  //every encrypted text is store here 
String decryptedText = "";  ////every decrypted text is store here 
String userInput = "";  //text provided to us by the user

String userInputUpper= "";  //changes the thirdUserInput to uppercase in our vigenere encryption function
String userInputLower= "";  //changes the userinput to lowercase in our cipher encryption function


int shiftKey = 0;  //the user gets to decide which key we should use for the caesar cipher
String keyInput ;  //user decides from 1 to 25 inclusive, which key to use


final String THE_ALPHABET = "abcdefghijklmnopqrstuvwxyz";  //we iterate over a string of letters which will give us each position a letter is
final String THE_ALPHABET_IN_CAPS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";  //we iterate over a string of capital letters which will give us each position a letter is in the vigenere cipher
final String KEYWORD = "OGHENETEGA";  //the keyword used in the vigenere cipher


String myChar;  //each character in our userinput
char eachLetter;  //each letter in the alphabet
boolean myBool = false;  //true if a char in our userInput is equal to a char in the alphabet
int num = 0;  //each char in our userinput is assigned a number that is KEY positions of that char

boolean wrongKey = true;  //true if the key/number the user enters is not between 1 and 25 inclusive

int plainNum = 0;  //Plaintext as a number - vigenere cipher
int keyNum;  //Key as a number - vigenere cipher

int vigEncrypt ;  //vigenere encryption formula
int vigDecrypt ;  //vigenere decryption formula
boolean isAllLetters = false;  //true if all the letters in userinput are all letters
boolean startAllOver = true;  //this is so our questions are asked forever except if the user enters "quit" in the main menu
String eachKeyChar;  ////each letter in our KEYWORD constant


//these are for character positions and booleans to test when we have 2 letters that are equal
String myChar2;  //each character in the thirduserinput
char eachLetter2;  //each letter in the alphabet when looking at the index position of the characters in our thirduserinput
boolean myBool2 = false;  //true if a char in our userInput is equal to a char in the alphabet
char eachLetter3;  //each letter in the alphabet when looking at the index position of the characters in KEYWORD
boolean myBool3 = false; //true if a char in our userInput is equal to a char in the alphabet
char myChar5;  //each character in the userinput
int m = 0;  //we use this to repeat our keyword e.g. COMPUTERCOMP
int n = 0;  //we use this to repeat our keyword e.g. OGHENETEGAOGHE




void setup() {
  noLoop();  //this is so the draw only runs once
}



void draw() {

  //we want to get a text before running the loop hence we use a do-while-loop
  do {

    userInput = JOptionPane.showInputDialog("Please enter \"Caesar\", \"Vigenere\" or \"Quit\". ");  //we allow the user to pick between three options
    boolean caesar = userInput.equalsIgnoreCase("Caesar");  //true if the user enters caesar
    boolean vigenere = userInput.equalsIgnoreCase("Vigenere");  //true if the user enters vigenere
    boolean quit = userInput.equalsIgnoreCase("Quit");  //true if the user enters quit


    if (vigenere) {
      vigenereEncrypt();
      vigenereDecrypt();
    }


    if (caesar) {

      //this inner do-while-loop allows us to ask the user for a key and then keeps prompting until we get a valid key
      do {
        keyInput = JOptionPane.showInputDialog("Please enter an integer value from 1 to 25 for the key");
        shiftKey = int(keyInput);
        if (shiftKey>=1 && shiftKey<=25) {  //if we have a validkey, set the wrongKey to false
          wrongKey = false;
        }
      } while (wrongKey);  //if we do not have a valid key, we have a wrong Key and wrongKey is set to true indefinitely (until the user gives a valid key)

      if (!wrongKey) {  //if we have a valid key we can ask for the plain and cipher texts respectively
        caesarEncrypt();
        caesarDecrypt();
      }
      wrongKey = true;  //resets wrongKey to true after we finish the current sets of questions
      //when we set the wrong key to true, we are making sure that the program asks the user again to verify that the key provided is valid
    }

    if (quit) {  //if the user types in "quit", we end the program.
      exit();
    }
  } while (startAllOver); //this is so our questions are asked forever except if the user enters "quit" in the main menu
}



/*
  This function encrypts a plain text entered by the user
 and prints out a statement with the text entered and the test encrypted
 using the caesar shift algorithm
 */
void caesarEncrypt() { 

  do {
    userInput = JOptionPane.showInputDialog("Please enter a plain text");
    checkALlLetters();
  } while (!isAllLetters);

  userInputLower = userInput.toLowerCase();  //converts the input string to lowercase

  for (int i=0; i<=(userInputLower.length())-1; i++) {  //iterates over the length of our userinput
    myChar = str(userInputLower.charAt(i));  //for each character in our userInput

    for (int j=0; j<=(THE_ALPHABET.length())-1; j++) {  //iterates over the length of the alphabet
      eachLetter = THE_ALPHABET.charAt(j);    //saves each letter from a to z into a char variable
      myBool = myChar.equals(str(eachLetter));  //true if a character in our userinput is equal to a letter in the alphabet

      if (myBool) {
        num = (j+shiftKey)%(THE_ALPHABET.length());  //ENCRYPTION FORMULA
        encryptedText = encryptedText + THE_ALPHABET.charAt(num);  //adds each cipher char to the encryption text
      }
    }
  }
  println("You entered the plaintext: " + userInput + " and the ciphertext is: " + encryptedText);
  encryptedText = "";  //reset the encrypted text
}



/*
  This function decrypts a cipher text entered by the user
 and prints out a statement with the text entered and the test decrypted
 using the caesar shift algorithm
 
 */
void caesarDecrypt() {

  do {
    userInput = JOptionPane.showInputDialog("Please enter a cipher text");
    checkALlLetters();
  } while (!isAllLetters);

  for (int i=0; i<=(userInput.length())-1; i++) {  //iterates over the length of our userinput
    myChar = str(userInput.charAt(i));  //for each character in our userInput


    for (int j=0; j<=(THE_ALPHABET.length())-1; j++) {  //iterates over the length of the alphabet
      eachLetter = THE_ALPHABET.charAt(j);    //saves each letter from a to z into a char variable
      myBool = myChar.equals(str(eachLetter));  //true if a character in our userinput is equal to a letter in the alphabet


      if (myBool) {
        num = (j-shiftKey)%(THE_ALPHABET.length());  //DECRYPTION FORMULA

        if (num<0) {
          num = num + THE_ALPHABET.length();  //if we have a negative position we want to add 26 to that value so we can get a letter from a to z
        }


        decryptedText = decryptedText + THE_ALPHABET.charAt(num);  //adds each cipher char to the encryption text
      }
    }
  }
  println("You entered the ciphertext: " + userInput + " and the plaintext is: " + decryptedText);
  decryptedText = "";  //reset the decrypted text
}


/*
This function checks each plaintext or ciphertext entered by the user
 to see if the user entered only letters.
 It doesn't return anything. We use a global varibale here instead.
 */

void checkALlLetters() {
  for (int i =0; i<= userInput.length()-1; i++) {
    myChar5 = userInput.charAt(i);  //each character the user entered
    boolean test = Character.isLetter(myChar5);  //true if a character is a letter
    if (!test) {
      isAllLetters = false;
      break;  //if false and the user entered a nonletter then we do not need to keep testing
    } else if (test) {
      isAllLetters = true;
    }
  }
}




/*
  This function encrypts a plain text entered by the user
 and prints out a statement with the text entered and the test encrypted
 using the vigenere cipher algorithm
 */
void vigenereEncrypt() {

  do {
    userInput = JOptionPane.showInputDialog("Please enter a plain text for vigenere encryption");
    checkALlLetters();
  } while (!isAllLetters);

  userInputUpper = userInput.toUpperCase();  //converts the input string to lowercase

  for (int i=0; i<=(userInputUpper.length())-1; i++) {
    myChar2 = str(userInputUpper.charAt(i));
    for (int j=0; j<=(THE_ALPHABET_IN_CAPS.length())-1; j++) {
      eachLetter2 = THE_ALPHABET_IN_CAPS.charAt(j);
      myBool2 = myChar2.equals(str(eachLetter2));  //if a char in the userinput is equal to a character in my list of letters
      if (myBool2) {
        plainNum = j;  //i.e. what is the index value of each letter the user enters

        m = (m)%KEYWORD.length();  //this here allows us to repeat our keyword i.e. OGHENETEGAOGHEN
        eachKeyChar = str(KEYWORD.charAt(m));  //each char in KEYWORD
        m++; 
        for (int l=0; l<=(THE_ALPHABET_IN_CAPS.length())-1; l++) {
          eachLetter3 = THE_ALPHABET_IN_CAPS.charAt(l);
          myBool3 = eachKeyChar.equals(str(eachLetter3));  //true if a character in KEYWORD is equal to a letter in the ALPHABET
          if (myBool3) {
            keyNum = l;

            vigEncrypt = (plainNum + keyNum) % THE_ALPHABET_IN_CAPS.length()  ;  // vigenere encryption formula / calculates the ciphertext as a number
            encryptedText = encryptedText + THE_ALPHABET.charAt(vigEncrypt);  //adds each character to the string "encryptedText"
          }
        }
      }
    }
  }
  encryptedText = encryptedText.toUpperCase();
  println("You entered the plaintext: " + userInput + " and the ciphertext is: " + encryptedText);
  encryptedText = "";  //reset the encrypted text
}



/*
  This function decrypts a cipher text entered by the user
 and prints out a statement with the text entered and the test decrypted
 using the vigenere cipher algorithm
 
 */
void vigenereDecrypt() {

  do {
    userInput = JOptionPane.showInputDialog("Please enter a plain text for vigenere decryption");
    checkALlLetters();
  } while (!isAllLetters);

  userInputUpper = userInput.toUpperCase();  //converts the input string to lowercase

  for (int i=0; i<=(userInputUpper.length())-1; i++) {
    myChar2 = str(userInputUpper.charAt(i));

    for (int j=0; j<=(THE_ALPHABET_IN_CAPS.length())-1; j++) {
      eachLetter2 = THE_ALPHABET_IN_CAPS.charAt(j);
      myBool2 = myChar2.equals(str(eachLetter2));  //if a char in the userinput is equal to a character in my list of letters

      if (myBool2) {
        plainNum = j;  //i.e. what is the index value of each letter the user enters
        n = (n)%KEYWORD.length();  //this here allows us to repeat our keyword i.e. OGHENETEGAOGHEN
        eachKeyChar = str(KEYWORD.charAt(n));  //each char in KEYWORD
        n++; 

        for (int l=0; l<=(THE_ALPHABET_IN_CAPS.length())-1; l++) {
          eachLetter3 = THE_ALPHABET_IN_CAPS.charAt(l);
          myBool3 = eachKeyChar.equals(str(eachLetter3));  //true if a character in KEYWORD is equal to a letter in the ALPHABET
          if (myBool3) {
            keyNum = l;
            vigDecrypt = (plainNum - keyNum + THE_ALPHABET_IN_CAPS.length()) % THE_ALPHABET_IN_CAPS.length()  ;  // vigenere decryption formula / calculates the plaintext as a number
            decryptedText = decryptedText + THE_ALPHABET.charAt(vigDecrypt);  //adds each character to the string "decryptedText"
          }
        }
      }
    }
  }
  decryptedText = decryptedText.toUpperCase();
  println("You entered the ciphertext: " + userInput + " and the plaintext is: " + decryptedText);
  decryptedText = ""; //reset the decrypted text
}
