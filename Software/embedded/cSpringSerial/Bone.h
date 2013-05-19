#include "Arduino.h"


const int minAccelerometerVal = 265;
const int maxAccelerometerVal = 402;

class Bone{
  private:
    byte pinX;
    byte pinY;
    byte pinZ;
    boolean xInverted;
    boolean yInverted;
    boolean zInverted;
    

  public: 
   
      double GetOrientationX(){
      double returnValue = 0;
      if(pinX != (byte)-1){
        returnValue = analogRead(pinX);
        returnValue = map(returnValue, minAccelerometerVal, maxAccelerometerVal, -90, 90);
      }else{
        returnValue = 0; 
      }
      if(xInverted){
        returnValue *= -1;
      }
      return returnValue;
    }
    double GetOrientationY(){
      double returnValue = 0;
      if(pinY != (byte)-1){
        returnValue = analogRead(pinY);
        returnValue = map(returnValue, minAccelerometerVal, maxAccelerometerVal, -90, 90);
      }else{
        returnValue = 0; 
      }
      if(yInverted){
        returnValue *= -1;
      }
      return returnValue;
    }
    double GetOrientationZ(){
      double returnValue = 0;
      if(pinZ != (byte)-1){
        returnValue = analogRead(pinZ);
        returnValue = map(returnValue, minAccelerometerVal, maxAccelerometerVal, -90, 90);
      }else{
        returnValue = 0; 
      }
      if(zInverted){
        returnValue *= -1;
      }
      return returnValue;
    }
      
    Bone(byte newPinX, boolean newXInverted, byte newPinY, boolean newYInverted, byte newPinZ, boolean newZInverted){
     
      pinX = newPinX;
      pinY = newPinY; 
      pinZ = newPinZ;
      xInverted = newXInverted;
      yInverted = newYInverted;
      zInverted = newZInverted;
    }
    
    
    void getCurrentPosition(){

      
      if(pinX != (byte)-1){
        Serial.print("<OrientationX>");
        Serial.print(GetOrientationX());
        Serial.print("</OrientationX>");
      }
      if(pinY != (byte)-1){
        Serial.print("<OrientationY>");
        Serial.print(GetOrientationY());
        Serial.print("</OrientationY>");
      }
      if(pinZ != (byte)-1){
        Serial.print("<OrientationZ>");
        Serial.print(GetOrientationZ());
        Serial.print("</OrientationZ>");
      }
      
    }
    
};
