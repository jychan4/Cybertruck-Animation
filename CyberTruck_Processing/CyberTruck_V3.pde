/*
  CYBERTRUCK
  by Yew Journ Chan

  Expects a string of comma-delimted Serial data from Arduino:
  ** first field is 0-4095 (potentiometer)
  ** second field is 0-4095 (LDR) 
  ** third field is 0 or 1 as a string(switch)
  
  will change the speed of the truck based on the potentiometer
  will turn on headlights based on the LDR
  will start/stop when switch is pressed
 */
 
 
 //Importing the serial library to communicate with the Arduino
import processing.serial.*;

// Initializing a variable named 'myPort' for serial communication
Serial myPort;      
String portName="/dev/tty.SLAB_USBtoUART";

//Data coming in from the data fields
String [] data;
int potValue = 0;
int sensorValue = 0;
int serialIndex = 0;

//Cybertruck Setup
PImage scrollingImage;     
PImage staticImage;
PImage drivingImage;
PImage textImage;
float counter;

//Scrolling from right to left
boolean bDrawImage1First = true;
float drawImage1X;
float drawImage2X;
float scrollRate = -10;

//sound
import processing.sound.*;
SoundFile badguy;

//--------------------------------------------------------------------------------
void setup() {
  size(1600,900);
  textAlign(CENTER);
  
  // List all the available serial ports
  printArray(Serial.list());
  // Set the com port and the baud rate according to the Arduino IDE
  myPort=new Serial(this, Serial.list()[serialIndex], 115200); 
  
  //loads images, function set to loop background
  textImage = loadImage("cybertruckTEXT.png");        //loads TEXT
  staticImage = loadImage("cybertruck.png");
  drivingImage = loadImage("truckla.gif");
  
  //loads moving background
  imageMode(CENTER);
  scrollingImage = loadImage("extendedbackground.png"); //loads backdrop
  drawImage1X = width/2;
  drawImage2X = drawImage2X + scrollingImage.width;

  loadBadguy();
}
//--------------------------------------------------------------------------------
void checkSerial(){
   while (myPort.available() > 0) {
     String inBuffer= myPort.readString();
     // print(inBuffer);
     //inBuffer = (trim(inBuffer)); // this removes the end-of-line from the string
   }
    if( data.length >= 2 ) {
     //data = split(inBuffer, ','); //this function will make an array of two items,(switch/ pot)
     potValue = int(data[1]);               // second index = pot value
   }
}
//--------------------------------------------------------------------------------
void Truckspeed(){
  if(potValue>=1000){  
    scrollRateincrease();
  } else {
    scrollRatedecrease();
  }
}
//--------------------------------------------------------------------------------
void scrollRateincrease(){
  scrollRate++;
}
void scrollRatedecrease(){
  scrollRate--;
}
void loadBadguy() {
  badguy = new SoundFile(this, "badguy.wav");
}
void playBadguy(){
  badguy.play();
  badguy.amp(0.09);
}

void stopBadguy(){
  badguy.stop();
}
//--------------------------------------------------------------------------------
void draw() {
  background(0);
  // Draw 1 side
  image(scrollingImage, drawImage1X, height/2);  
  // Draw 1 side
  image(scrollingImage, drawImage2X, height/2);
  

  // update image position
  if( bDrawImage1First == true ) {
    // Add position 2 to position 1
    drawImage1X = drawImage1X + scrollRate;
    drawImage2X = drawImage1X + scrollingImage.width;
    


    // check to see if position 1 is offscreen
    if( drawImage1X < -scrollingImage.width/2 )
      bDrawImage1First = false;

      
  }  
  else {
    // Add position 2 to position 1
    drawImage2X = drawImage2X + scrollRate;
    drawImage1X = drawImage2X + scrollingImage.width;
    scrollRatedecrease();

     // check to see if position 1 is offscreen
    if( drawImage2X < -scrollingImage.width/2 )
      bDrawImage1First = true;
      

      
  }
  image(staticImage,750,695); 
  
  
}
//--------------------------------------------------------------------------------  
