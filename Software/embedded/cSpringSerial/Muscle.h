#include "Arduino.h"

class Muscle{
  private:
    byte servoArmLength;
    byte linkageArmLength;
    byte servoToJointLength;
    byte linkageToJointLength;
    //String name;
    byte servoPin;
    byte maxSignal;
    byte minSignal;
    byte maxAngle;
    byte minAngle;
    char servoToAngleScallerValue;
    char balanceOffset;
    Muscle * next;
    static Muscle * first;
    Muscle(){}
  
  
  public: 
  
    byte  CurrentSignal;
    byte  GoalSignal;
    unsigned long GoalTime;
    int StepMS;
    long TimeRemaining;
    
    Servo myServo;
  
    Muscle(byte newServoPin, char newServoToAngleScallerValue, byte newMinSignal, byte newMaxSignal, byte newMinAngle, byte newMaxAngle, byte newServoArmLength, byte newLinkageArmLength, byte newServoToJointLength, byte newLinkageToJointLength){
  
      servoArmLength = newServoArmLength;
      linkageArmLength = newLinkageArmLength;
      servoToJointLength = newServoToJointLength;
      linkageToJointLength = newLinkageToJointLength;
      
      servoPin = newServoPin;
      servoToAngleScallerValue = newServoToAngleScallerValue;
      CurrentSignal = 90;
      maxSignal = newMaxSignal;
      minSignal = newMinSignal;
      maxAngle = newMaxAngle;
      minAngle = newMinAngle;
      GoalSignal = CurrentSignal;
      GoalTime = 0;
      
      next = first;
      first = this;
      Serial.println((int)this);   
      Serial.println("Constructor");      
      myServo.attach(servoPin);
      balanceOffset = 0;
    }
    /*
    Muscle(String newName, byte newServoPin, char newServoToAngleScallerValue, byte newMinSignal, byte newMaxSignal){
      name = newName;
      servoPin = newServoPin;
      servoToAngleScallerValue = newServoToAngleScallerValue;
      CurrentSignal = 90;
      maxSignal = newMaxSignal;
      minSignal = newMinSignal;
      GoalSignal = CurrentSignal;
      GoalTime = 0;
      
      next = first;
      first = this;
      Serial.println((int)this);   
      Serial.println("Constructor");      
      myServo.attach(servoPin);

    }
    */
    byte AdjustForScallerValue(byte inputAdjustment){
      return ((((char)inputAdjustment - 90) * servoToAngleScallerValue) + 90); 
    }
    
    void Move(char distanceToMove, int & MillisencondsToGetThere){
      SetNewGoal(CurrentSignal + distanceToMove, MillisencondsToGetThere);
    }
    
    void SetNewGoal(byte SpotToFlexTo, int MillisecondsToGetThere){
      GoalSignal = SpotToFlexTo;
      
      if(GoalSignal > maxSignal){
        GoalSignal = maxSignal;
      }    
      if(GoalSignal < minSignal){
        GoalSignal = minSignal;
      }   
      
      if(MillisecondsToGetThere > 0 && (CurrentSignal != GoalSignal)){
        GoalTime = millis() + MillisecondsToGetThere;     
        StepMS = MillisecondsToGetThere / (CurrentSignal - GoalSignal);     
      }
       
    }
    
    void SetBalanceOffset(char balanceOffsetNew){
      balanceOffset = balanceOffsetNew;
    }
    
    void MoveTowardGoal(){
      TimeRemaining = GoalTime - millis();
      if(TimeRemaining > 0){
        CurrentSignal = GoalSignal + (TimeRemaining / StepMS); 
            
      }else{
        CurrentSignal = GoalSignal;
        GoalTime = 0;
        StepMS = 0;
      }  
      FlexTo();
    } 
   
    void FlexTo(){     
      myServo.write(AdjustForScallerValue(CurrentSignal)); 
    }
    
    byte GetCurrentAngle(){
       float maxSignalDistance = maxSignal - minSignal;
       float maxAngleDistance = maxAngle - minAngle;
       byte angle = CurrentSignal - minSignal;
       angle = angle * (float)((float)maxSignalDistance / (float)maxAngleDistance);
       
       angle = angle + minAngle;
       return angle;
    }
    
    
     static void UpdateAll(){
       //serialEvent();
       for (Muscle *p = first; p != 0; p = p->next){
         p->MoveTowardGoal();
         //Serial.println((int)p);
       }
       
     } 
     
     
     static boolean AllAtGoal(){
       boolean allAreAtGoal = true;
       for (Muscle *p = first; p != 0 && allAreAtGoal; p = p->next){
         allAreAtGoal = (p->GoalTime == 0);
       }
       return allAreAtGoal;
     }  
     
     static long TimeTillGoal(){
       long maxTime = 0;
       for (Muscle *p = first; p != 0; p = p->next){
         if(maxTime < p->TimeRemaining){
           maxTime = p->TimeRemaining;
         }
       }
       return maxTime;
     }  
     
     static int MusclesStillMoving(){
       int musclesStillMoving = 0;
       for (Muscle *p = first; p != 0; p = p->next){
         if(p->GoalTime > 0){
           musclesStillMoving++;
         }
       }
       return musclesStillMoving;
     }  
     
       
    void doAction(Action* command){
      QueueList<String> SplitInput = Split(command->CommandName, '.');
      if(SplitInput.count() > 1){
        String objectName = SplitInput.pop();        
        
        //reconstruct CommandName
        command->CommandName = "";
        while(SplitInput.count() > 0){
            command->CommandName += SplitInput.pop();
            if(SplitInput.count() > 0)
              command->CommandName += ".";
        }
        
      }else if(SplitInput.count() == 1){
        //DoAction
        if(SplitInput.peek() == "setnewgoal"){
          SetNewGoal(command->Distance, command->Duration);
        }
        if(SplitInput.peek() == "move"){
          Move(command->Distance, command->Duration);
        }
      }
    }
    
    
    void getCurrentPosition(){

      Serial.print("<Position>");
      Serial.print(CurrentSignal);
      Serial.print("</Position>");
      Serial.print("<Distance To Goal>");
      if(StepMS > 0){
        Serial.print((TimeRemaining / StepMS));
      }else{
        Serial.print(0);
      }
      Serial.print("</Distance To Goal>");

    }
    
};


