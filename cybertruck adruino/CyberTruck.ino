/*
  CyberTruck
  by Journ Chan
  Send potentiometer and LDR sensor data to a sketch in processing
 */

int ledPin=15;
int buttonPin=12;
int potInputPin=A2;
int ldrInputPin=A1;

//-- analog values, track for formatting to serial
int switchValue=0;
int potValue=0;
int ldrValue=0;
int buttonCounter=1;


// the setup function runs once when you press reset or power the board
void setup() {
  // initialize pins and input and output
  pinMode(ledPin, OUTPUT);    
  pinMode(buttonPin, INPUT);
  pinMode(potInputPin, INPUT);    // technically not needed, but good form
  pinMode(ldrInputPin,INPUT);
  
  Serial.begin(115200);
 // Serial.println( "ButtonLED: Starting" ); 
}

// the loop function runs over and over again forever
void loop() {
  // gets switch Value AND changed LED
  getPotValue();
  getLDRValue();  
  sendSerialData();
 
  // delay so as to not overload serial buffer
  delay(100);
}



void getPotValue() {
  potValue=analogRead(potInputPin); 
}

void getLDRValue() {
  ldrValue=analogRead(ldrInputPin); 
}

//-- this could be done as a formatted string, using Serial.printf(), but
//-- we are doing it in a simpler way for the purposes of teaching
void sendSerialData() {
  // Add switch on or off (Not used in Processing sketch
  if(buttonCounter%2==0) 
  {
    Serial.print(1);
  }
  else if(buttonCounter%2!=0)
  {
    Serial.print(0);
  }

   Serial.print(",");
   Serial.print(potValue);

   Serial.print(",");
   Serial.print(ldrValue);
   
  // end with newline
  Serial.println();
}
