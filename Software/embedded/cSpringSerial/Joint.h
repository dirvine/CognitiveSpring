#include "Arduino.h"

class Joint{
  private:
    String name;
    
  public:
    
//    Bone *lowerBone;
//    Bone *upperBone;
    Muscle *muscleX;
    Muscle *muscleY;
    Muscle *muscleZ;
   // Muscle *muscleTwistX;
   // Muscle *muscleTwistY;
   // Muscle *muscleTwistZ;
   
    //Bone *newLowerBone, Bone *newUpperBone, 
    Joint(Muscle *newMuscleX, Muscle *newMuscleY, Muscle *newMuscleZ){//, Muscle *newMuscleTwistX, Muscle *newMuscleTwistY, Muscle *newMuscleTwistZ){
//      lowerBone = newLowerBone;
//      upperBone = newUpperBone;
      muscleX = newMuscleX;
      muscleY = newMuscleY;
      muscleZ = newMuscleZ;
      //muscleTwistX = newMuscleTwistX;
      //muscleTwistY = newMuscleTwistY;
      //muscleTwistZ = newMuscleTwistZ;
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
        if(objectName == "musclex"){
          if(muscleX != 0)
             muscleX->doAction(command);
        }else if(objectName == "muscley"){
           if(muscleY != 0)
             muscleY->doAction(command);
        }else if(objectName == "musclez"){
           if(muscleZ != 0)
             muscleZ->doAction(command);
        }
        
      }
        
    }

    void getCurrentPosition(){

      
      if(muscleX != 0){
        Serial.print("<MuscleX>");
        muscleX->getCurrentPosition();
        Serial.print("</MuscleX>");
      }
      if(muscleY != 0){
        Serial.print("<MuscleY>");
        muscleY->getCurrentPosition();
        Serial.print("</MuscleY>");
      }
      if(muscleZ != 0){
        Serial.print("<MuscleZ>");
        muscleZ->getCurrentPosition();
        Serial.print("</MuscleZ>");
      }
      

    }
  
};
