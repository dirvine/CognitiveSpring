#include "Arduino.h"
//#include <StackArray.h>
   
boolean PowerOn = false;



class cSpring{
  private:
  
    void setupAndDefineRobot(){
      Muscle *LeftKneeMuscle;
      Muscle *LeftAnkleFBMuscle;
      Muscle *LeftAnkelLRMuscle;
      Muscle *LeftHipFBMuscle;
      Muscle *LeftHipTwistLRMuscle;
      Muscle *LeftHipLRMuscle;
    
      Muscle *RightKneeMuscle;
      Muscle *RightAnkleFBMuscle;
      Muscle *RightAnkelLRMuscle;
      Muscle *RightHipFBMuscle;
      Muscle *RightHipTwistLRMuscle;
      Muscle *RightHipLRMuscle;
      
      Bone *LeftFoot;
      Bone *LeftShin;
      Bone *LeftThigh;
      Bone *RightFoot;
      Bone *RightShin;
      Bone *RightThigh;
      
     
      LeftAnkelLRMuscle = new Muscle(2, -1, 20, 150, 0, 180, 10, 100, 50, 50);
      LeftAnkleFBMuscle = new Muscle(3, 1, 20, 150, 0, 180, 10, 100, 50, 50);
      LeftKneeMuscle = new Muscle(4, 1, 15, 150, 0, 180, 10, 100, 50, 50);
      LeftHipLRMuscle = new Muscle(5, 1, 35, 155, 0, 180, 10, 100, 50, 50);
      LeftHipTwistLRMuscle = new Muscle(6, 1, 20, 150, 0, 180, 10, 100, 50, 50);
      LeftHipFBMuscle = new Muscle(7, -1, 0, 155, 0, 180, 10, 100, 50, 50);
    
      RightAnkelLRMuscle = new Muscle(8, 1, 20, 150, 0, 180, 10, 100, 50, 50);
      RightAnkleFBMuscle = new Muscle(9, -1, 20, 150, 0, 180, 10, 100, 50, 50);
      RightKneeMuscle = new Muscle(10, -1, 15, 150, 0, 180, 10, 100, 50, 50);
      RightHipLRMuscle = new Muscle(11, -1, 35, 155, 0, 180, 10, 100, 50, 50);
      RightHipTwistLRMuscle = new Muscle(12, -1, 20, 150, 0, 180, 10, 100, 50, 50);
      RightHipFBMuscle = new Muscle(13, 1, 0, 155, 0, 180, 10, 100, 50, 50);
      
      LeftFoot = new Bone(0, true, -1, false, 1, true);
      LeftShin = new Bone(2, true, -1, false, 3, true);
      LeftThigh = new Bone(11, true, -1, false, 10, true);
      RightFoot = new Bone(6, true, -1, false, 7, true); 
      RightShin = new Bone(8, true, -1, false, 9, true); 
      RightThigh = new Bone(5, true, -1, false, 4, true);
      torso = new Bone(12, false, -1, false, 13, false); 
      
      left = new Leg(LeftFoot, LeftAnkelLRMuscle, LeftAnkleFBMuscle, LeftShin, LeftKneeMuscle, LeftThigh, LeftHipLRMuscle, LeftHipTwistLRMuscle, LeftHipFBMuscle);
      right = new Leg(RightFoot, RightAnkelLRMuscle, RightAnkleFBMuscle, RightShin, RightKneeMuscle, RightThigh, RightHipLRMuscle, RightHipTwistLRMuscle, RightHipFBMuscle);
      
      left->StaticSquat(10, 500);
      right->StaticSquat(10, 500);
    }
    
  public:
  
    String responseString;
    ActionSequence actionSequenceInExecution; 
  
    String name;
    Leg *left;
    Leg *right;
    Bone *torso;
  
    cSpring(){
      responseString = "";
      pinMode(52, OUTPUT);  
      setupAndDefineRobot();
      actionSequenceInExecution.parsingInputCommands = false;
      //Stand();
    }
    
    boolean ReadyForNextActions(){
      return Muscle::AllAtGoal();
    }
   
   void StandOnRight(){
     //shiftright,40,6000&right.toedown,4,6000>right.liftbody,90,6000
   }
     
    //Actions
    void On(){
      PowerOn = true;
      digitalWrite(23, HIGH);;
      digitalWrite(25, HIGH);;
      digitalWrite(27, HIGH);;
      digitalWrite(29, HIGH);
           digitalWrite(52, HIGH); 
    }
    void Off(){
      PowerOn = false;
      digitalWrite(23, LOW); 
      digitalWrite(25, LOW); 
      digitalWrite(27, LOW); 
      digitalWrite(29, LOW); 
            digitalWrite(52, LOW); 
    }
    
    int GetVoltage(){
       return analogRead(15);
    }
    int GetCurrent(){
      return analogRead(14);
    }
    
    void Stand(byte distance, int duration){
         left->StaticStand(distance, duration);
         right->StaticStand(distance, duration);
    }
    
    void Squat(byte distance, int duration){
         left->StaticSquat(distance, duration);
         right->StaticSquat(distance, duration);
    }
    
    void ShiftLeft(byte distance, int duration){
        right->LeanOut(distance, duration);
        left->LeanIn(distance, duration);
    }
    
    void ShiftRight(byte distance, int duration){
        left->LeanOut(distance, duration);
        right->LeanIn(distance, duration);
    }
    
    void TwistLeft(byte distance, int duration){
        right->TwistOut(distance, duration);
        left->TwistIn(distance, duration);
    }
    
    void TwistRight(byte distance, int duration){
        left->TwistOut(distance, duration);
        right->TwistIn(distance, duration);
    }
    void LeanForward(byte distance, int duration){
      //left->hip->muscleX->Move(distance, duration);
      //right->hip->muscleX->Move(distance, duration);
      left->ankle->muscleX->Move(-distance, duration);
      right->ankle->muscleX->Move(-distance, duration);
    }
    void LeanBack(byte distance, int duration){
      //left->hip->muscleX->Move(-distance, duration);
      //right->hip->muscleX->Move(-distance, duration);
      left->ankle->muscleX->Move(distance, duration);
      right->ankle->muscleX->Move(distance, duration);
    }
    
    void BendForward(byte distance, int duration){
      //left->hip->muscleX->Move(distance, duration);
      //right->hip->muscleX->Move(distance, duration);
      //left->ankle->muscleX->Move(left->ankle->muscleX->CurrentSignal + distance, duration);
      //right->ankle->muscleX->Move(right->ankle->muscleX->CurrentSignal + distance, duration);
      left->MoveForward(distance, duration);
      right->MoveForward(distance, duration);
    }
    void BendBack(byte distance, int duration){
      //left->hip->muscleX->Move(-distance, duration);
      //right->hip->muscleX->Move(-distance, duration);
      //left->ankle->muscleX->Move(left->ankle->muscleX->CurrentSignal - distance, duration);
      //right->ankle->muscleX->Move(right->ankle->muscleX->CurrentSignal - distance, duration);
      left->MoveBackward(distance, duration);
      right->MoveBackward(distance, duration);
    }
    
    
    void StandOnLeft(int duration){
      ShiftLeft(40, 4000);
      right->LeanIn(50, duration);
      
    }
     //LegSequences ?? Explore more 
    void StepForward(int duration){
      
         ShiftLeft(10, 4000);
      
      // then
        while(!Muscle::AllAtGoal()){
          Muscle::UpdateAll();
        }
        
        left->LiftBody(10, 4000);
        
        // then
        while(!Muscle::AllAtGoal()){
          Muscle::UpdateAll();
        }
        
        //Kinda??
        left->TwistIn(10, 4000);
        right->TwistOut(10, 4000);
        left->MoveBackward(10, 4000);
        right->MoveForward(10, 4000);
        
        // then
        while(!Muscle::AllAtGoal()){
          Muscle::UpdateAll();
        }
        
        //ExtendToe
        //left->Extend(20, 4000);
        //Lean Forward?
        
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
        
        Serial.println(objectName);
        
        //Pass onto object
        if(objectName == "left"){
           left->doAction(command);
        }else if(objectName == "right"){
           right->doAction(command);
        }
        
      }else if(SplitInput.count() == 1){
        //DoAction
        if(SplitInput.peek() == "off"){
          Off();
        }
        if(SplitInput.peek() == "on"){
          On();
        }
        if(SplitInput.peek() == "stand"){
          Stand(command->Distance, command->Duration);
        }
       if(SplitInput.peek() == "squat"){
          Squat(command->Distance, command->Duration);
       }
       if(SplitInput.peek() == "shiftleft"){
          ShiftLeft(command->Distance, command->Duration);
       }
       if(SplitInput.peek() == "shiftright"){
          ShiftRight(command->Distance, command->Duration);
       }
       if(SplitInput.peek() == "twistleft"){
          TwistLeft(command->Distance, command->Duration);
       }
       if(SplitInput.peek() == "twistright"){
          TwistRight(command->Distance, command->Duration);
       }
       if(SplitInput.peek() == "bendforward"){
          BendForward(command->Distance, command->Duration);
       }
       if(SplitInput.peek() == "bendback"){
          BendBack(command->Distance, command->Duration);
       }
       if(SplitInput.peek() == "leanforward"){
          LeanForward(command->Distance, command->Duration);
       }
       if(SplitInput.peek() == "leanback"){
          LeanBack(command->Distance, command->Duration);
       }
       if(SplitInput.peek() == "standonleft"){
          StandOnLeft(command->Duration);
       }
      }
    }
    
void getCurrentPosition(){
      
      
      Muscle::UpdateAll();
//        actionSequenceInExecution.parsingInputCommands = true;
      if(!actionSequenceInExecution.parsingInputCommands){
          Serial.print("<cSpring>"); 
          Serial.print("<Status>");
          Serial.print("<PowerOn>");
          Serial.print(PowerOn);
          Serial.print("</PowerOn>");    
          Serial.print("<Voltage>");
          Serial.print(GetVoltage());
          Serial.print("</Voltage>");  
          Serial.print("<Current>");
          Serial.print(GetCurrent());
          Serial.print("</Current>");    
          Serial.print("<FinishedMoving>");
          Serial.print(Muscle::AllAtGoal());
          Serial.print("</FinishedMoving>"); 
          
          Serial.print("<NumberOfMusclesStillMoving>");
          Serial.print(Muscle::MusclesStillMoving());
          Serial.print("</NumberOfMusclesStillMoving>"); 
          
          Serial.print("<TimeTillAtGoal>");
          Serial.print(Muscle::TimeTillGoal());
          Serial.print("</TimeTillAtGoal>"); 
          
          Serial.print("<NumberOfActionsSequencesRemaining>");
          Serial.print(actionSequenceInExecution.SequenceToTake.count());
          Serial.print("</NumberOfActionsSequencesRemaining>"); 
//        
//        Serial.print("<OtherResponses>");
//        Serial.print(responseString);
//        Serial.print("</OtherResponses>"); 
        
          Serial.print("</Status>");
      }
        Muscle::UpdateAll();
      
      if(!actionSequenceInExecution.parsingInputCommands){
        
          Serial.print("<Body>");
          
          Serial.print("<Torso>");
          torso->getCurrentPosition();
          Serial.print("</Torso>");
          
          Serial.print("<LeftLeg>");
          left->getCurrentPosition();
          Serial.print("</LeftLeg>");
      
      }
        Muscle::UpdateAll();
      
      if(!actionSequenceInExecution.parsingInputCommands){ 
        
          Serial.print("<RightLeg>");
          right->getCurrentPosition();
          Serial.print("</RightLeg>");
          Serial.print("</Body>");
          Serial.println("</cSpring>");
          
          if(responseString != ""){
            Serial.println(responseString);       
            responseString = "";
          }

      }
      
}
   
    
    
  void doActionSequence(){
    if(actionSequenceInExecution.IsOverrideCurrentAction() || ReadyForNextActions()){
       if(actionSequenceInExecution.SequenceToTake.count() > 0){
         ActionCollection* nextActions = actionSequenceInExecution.SequenceToTake.pop();
         ActionCollection* saveActions = new ActionCollection();
         
         
         while(nextActions->ActionsToTake.count() > 0){
           //Serial.println("never ending?");
           Action* eachAction = nextActions->ActionsToTake.pop();
           //doActionManual(eachAction);
           if(nextActions->Looping){
             Action* newAction = new Action();
             (*newAction) = (*eachAction);
              saveActions->ActionsToTake.push(newAction);
           }
           doAction(eachAction);
           delete eachAction;
         }
         
         if(nextActions->Looping){
             Serial.print("TryingToLoop:");
             Serial.println(saveActions->ActionsToTake.count());
             saveActions->Looping = true;
             actionSequenceInExecution.SequenceToTake.push(saveActions);
         }else{
           delete saveActions;
         }
         delete nextActions;
         if(actionSequenceInExecution.SequenceToTake.count() == 0){
           responseString =+ "Sequence Finished.\n";
         }
       }
    }else{
      //Serial.print(".");
    }
  }
  
  
  
};
