#include "Arduino.h"

class Leg{
  private:
    
    
  public:
  
   // String name;
    Joint *hip;
    Joint *knee;
    Joint *ankle;
    Bone *foot;
    Bone *shin;
    Bone *thigh;
    
      Leg(Bone* newFoot, Muscle *AnkelLRMuscle, Muscle *AnkleFBMuscle, Bone* newShin, Muscle *KneeMuscle, Bone* newThigh, Muscle *HipLRMuscle, Muscle *HipTwistLRMuscle, Muscle *HipFBMuscle){

        foot = newFoot;
        shin = newShin;
        thigh = newThigh;
        
        hip = new Joint(HipFBMuscle, HipTwistLRMuscle, HipLRMuscle);
        knee = new Joint(KneeMuscle, 0, 0);
        ankle = new Joint(AnkleFBMuscle, 0, AnkelLRMuscle);
      
        
      }
  
  //Leg actions
    void Extend(char distance, int duration){
      ankle->muscleX->Move(distance, duration);
      knee->muscleX->Move((distance * 2), duration); // Remove and use the Muscle.
      //hip->muscleX->Move(distance, duration);
    }
    void Bend(char distance, int duration){
      ankle->muscleX->Move( - distance, duration);
      knee->muscleX->Move( - (distance * 2), duration); // Remove and use the Muscle.
      //hip->muscleX->Move(distance, duration);
    }
    
    void MoveIn(char distance, int duration){
      //ankle->muscleZ->Move(distance, duration);
      hip->muscleZ->Move( - distance, duration); // Remove and use the Muscle.
      //hip->muscleX->Move(distance, duration);
    }
    void MoveOut(char distance, int duration){
      //ankle->muscleZ->Move( - distance, duration);
      hip->muscleZ->Move(distance, duration); // Remove and use the Muscle.
      //hip->muscleX->Move(distance, duration);
    }
    void MoveForward(char distance, int duration){
      //ankle->muscleX->Move(distance, duration);
      hip->muscleX->Move(distance, duration);
    }
    void MoveBackward(char distance, int duration){
      //ankle->muscleX->Move( - distance, duration);
      hip->muscleX->Move(-distance, duration);
    }
    void LiftBody(char distance, int duration){
      //ankle->muscleZ->Move( - distance, duration);
      hip->muscleZ->Move(distance, duration);
    }
    void LowerBody(char distance, int duration){
      //ankle->muscleZ->Move(distance, duration);
      hip->muscleZ->Move( - distance, duration);
    }
    void LeanIn(char distance, int duration){
      ankle->muscleZ->Move(distance, duration);
      hip->muscleZ->Move( - distance, duration);
    }
    void LeanOut(char distance, int duration){
      ankle->muscleZ->Move( - distance, duration);
      hip->muscleZ->Move(distance, duration);
    }
    void LeanForward(char distance, int duration){
      ankle->muscleX->Move(-distance, duration);
      hip->muscleX->Move(distance, duration);
    }
    void LeanBackward(char distance, int duration){
      ankle->muscleX->Move(distance, duration);
      hip->muscleX->Move(-distance, duration);
    }
    void TwistIn(char distance, int duration){
      hip->muscleY->Move(distance, duration);
    }
    void TwistOut(char distance, int duration){
      hip->muscleY->Move( - distance, duration);
    }
    void ToeDown(char distance, int duration){
      ankle->muscleX->Move(distance, duration);
    }
    void ToeUp(char distance, int duration){
      ankle->muscleX->Move( - distance, duration);
    }
      
  //Static Poses
  
    void StaticStand(byte distance, int duration){
      ankle->muscleX->SetNewGoal(79, duration);
      ankle->muscleZ->SetNewGoal(84, duration);
      //LeftAnkelLRMuscle->SetNewGoal(80, duration);   
      //LeftAnkleFBMuscle->SetNewGoal(75, duration); 
      
      knee->muscleX->SetNewGoal(175, duration);
      //LeftKneeMuscle->SetNewGoal(150, duration);  
      
      hip->muscleX->SetNewGoal(60, duration);
      hip->muscleY->SetNewGoal(70, duration);
      hip->muscleZ->SetNewGoal(65, duration);
      //LeftHipFBMuscle->SetNewGoal(75, duration);     
      //LeftHipTwistLRMuscle->SetNewGoal(90, duration);  
      //LeftHipLRMuscle->SetNewGoal(90, duration);    
    }

    void StaticSquat(byte distance, int duration){
      
        ankle->muscleX->SetNewGoal(57, duration);
        ankle->muscleZ->SetNewGoal(92, duration);
        //LeftAnkelLRMuscle->SetNewGoal(80, duration);    
        //LeftAnkleFBMuscle->SetNewGoal(25, duration);
     
        knee->muscleX->SetNewGoal(39, duration);
        //LeftKneeMuscle->SetNewGoal(75, duration);   
              
        hip->muscleX->SetNewGoal(90, duration);
        hip->muscleY->SetNewGoal(70, duration);
        hip->muscleZ->SetNewGoal(75, duration);
        //LeftHipFBMuscle->SetNewGoal(0, duration); 
        //LeftHipTwistLRMuscle->SetNewGoal(90, duration);  
        //LeftHipLRMuscle->SetNewGoal(90, duration);     
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
        
        
        //Serial.println(objectName);
        //Pass onto object
        if(objectName == "ankle"){
           ankle->doAction(command);
        }else if(objectName == "knee"){
           knee->doAction(command);
        }else if(objectName == "hip"){
           hip->doAction(command);
        }
        
      }else if(SplitInput.count() == 1){
        
       if(command->CommandName == "extend"){
          Extend(command->Distance, command->Duration);
       }
       if(command->CommandName == "bend"){
          Bend(command->Distance, command->Duration);
       }
       if(command->CommandName == "movein"){
          MoveIn(command->Distance, command->Duration);
       }
       if(command->CommandName == "moveout"){
          MoveOut(command->Distance, command->Duration);
       }
       if(command->CommandName == "moveforward"){
          MoveForward(command->Distance, command->Duration);
       }
       if(command->CommandName == "moveback"){
          MoveBackward(command->Distance, command->Duration);
       }
       if(command->CommandName == "liftbody"){
          LiftBody(command->Distance, command->Duration);
       }
       if(command->CommandName == "lowerbody"){
          LowerBody(command->Distance, command->Duration);
       }
       if(command->CommandName == "leanin"){
          LeanIn(command->Distance, command->Duration);
       }
       if(command->CommandName == "leanout"){
          LeanOut(command->Distance, command->Duration);
       }
       if(command->CommandName == "leanforward"){
          LeanForward(command->Distance, command->Duration);
       }
       if(command->CommandName == "leanback"){
          LeanBackward(command->Distance, command->Duration);
       }
       if(command->CommandName == "twistin"){
          TwistIn(command->Distance, command->Duration);
       }
       if(command->CommandName == "twistout"){
          TwistOut(command->Distance, command->Duration);
       }
       if(command->CommandName == "toedown"){
          ToeDown(command->Distance, command->Duration);
       }
       if(command->CommandName == "toeup"){
          ToeUp(command->Distance, command->Duration);
       }
      }
      
    }
    
    void getCurrentPosition(){
      Muscle::UpdateAll();
      Serial.print("<Hip>");
      hip->getCurrentPosition();
      Muscle::UpdateAll();
      Serial.print("</Hip>");
      Serial.print("<Thigh>");
      thigh->getCurrentPosition();
      Muscle::UpdateAll();
      Serial.print("</Thigh>");
      Serial.print("<Knee>");
      knee->getCurrentPosition();
      Muscle::UpdateAll();
      Serial.print("</Knee>");
      Serial.print("<Shin>");
      shin->getCurrentPosition();
      Muscle::UpdateAll();
      Serial.print("</Shin>");
      Serial.print("<Ankle>");
      ankle->getCurrentPosition();
      Muscle::UpdateAll();
      Serial.print("</Ankle>");
      Serial.print("<Foot>");
      foot->getCurrentPosition();
      Muscle::UpdateAll();
      Serial.print("</Foot>");
      

    }
  
};
