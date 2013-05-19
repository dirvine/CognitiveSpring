
 //this is the one
//#include <SerialManager.h>
//#include <ByteBuffer.h>
#include <Servo.h> 
#include <QueueList.h>
#include "Action.h"
#include "Muscle.h"
#include "Bone.h"
#include "Joint.h"
#include "Leg.h"
#include "cSpring.h"

Muscle *Muscle::first = 0;


cSpring *devCS;     
    

String inputString = "";  
boolean stringComplete = false;  // whether the string is complete
      
void setup() 
{   
  Serial.begin(115200);
  devCS = new cSpring();
  //actionSequenceInExecution = new ActionSequence();
  
  devCS->responseString =+ "OUT:setup\n";        
} 
 
 
void loop() 
{   
    //devCS->serialHandler();
    devCS->doActionSequence();
    Muscle::UpdateAll();
    devCS->getCurrentPosition();
    
} 


void serialEvent() {
  //Serial.flush();
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read();
    
    if (inChar == ';') {
      stringComplete = true;
    }else{
      // add it to the inputString:
      if(inChar != '\n'){
        inputString += inChar;
        //devCS->actionSequenceInExecution.parsingInputCommands = true;
      }
    }
  }
  
  if(stringComplete){
    //Action command;
    //command.CommandName = inputString;
    //devCS->doAction(command);
    if(inputString.length() > 1){
      inputString.toLowerCase();
      devCS->actionSequenceInExecution.ParseActionSequence(inputString);
    }
    
    
    devCS->responseString += "action sequence loaded:";
    devCS->responseString += inputString;
    devCS->responseString += "\n";
    //printActionSequence();
    stringComplete = false;
    inputString = "";
    
    //devCS->actionSequenceInExecution.parsingInputCommands = false;
  }
  
}

  

