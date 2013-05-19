#include "Arduino.h"

    

static QueueList<String> Split (String &inputString, char splitCharacter){
  QueueList<String> returnArray;
  
  String eachSplitString = "";
  
  for(int index = 0; index < inputString.length(); index++){
    if(inputString[index] != splitCharacter && inputString[index] != ' '){
      eachSplitString += inputString[index];
    }else if(inputString[index] == splitCharacter){
      returnArray.push(eachSplitString);
      eachSplitString = "";
    }
  }
  returnArray.push(eachSplitString);
  return returnArray;
}





class Action{
  private:
  public: 
    String CommandName;
    byte Distance; 
    int Duration;   
     
    Action(){
       CommandName = "none";
       Distance = 2;
       Duration = 500;
    }

    void parseAction(String &serialStringInput){
      QueueList<String> SplitInput = Split(serialStringInput, ',');
      
      if(SplitInput.count() == 3){
        CommandName = SplitInput.pop();
        
        char characterArray[SplitInput.peek().length() + 1];
        SplitInput.pop().toCharArray(characterArray, sizeof(characterArray));
        Distance = (byte)atoi(characterArray);
        
        char characterArray2[SplitInput.peek().length() + 1];
        SplitInput.pop().toCharArray(characterArray2, sizeof(characterArray2));
        Duration = atoi(characterArray2);
      }else if(SplitInput.count() == 1){
        CommandName = SplitInput.pop(); 
      } 
      
      //Serial.println(CommandName);
    } 
};


class ActionCollection {
  private:
  public:
  // ! : Do this now
  // > : Then do this // Add to Sequence
  // @ : Loop do this // When you do this action, push it into a FIFO queue;
    boolean Looping;
  // & : And do this Too // Standard Action
    
    QueueList<Action*> ActionsToTake;
    
    ActionCollection(){
      ActionsToTake = QueueList<Action*>();
    }
    
    
    ~ActionCollection(){
      //Serial.println("ActionCollectionDieing");
        //while(!ActionsToTake->isEmpty()){
        //      ActionsToTake->pop();
        //}      
        //delete ActionsToTake;
    }
    
    void ParseActions(String & serialStringInput){
      //Serial.println(serialStringInput);
      QueueList<String> SplitInput = Split(serialStringInput, '&');
      while (SplitInput.count() > 0){
        String valuevalue = SplitInput.pop();
        Action* command = new Action();
        command->parseAction(valuevalue);
        ActionsToTake.push(command);
      } 
    }
    
};

class ActionSequence{
  private:
    boolean loopTillNextInput;
    boolean overrideCurrentAction;
    boolean insertIntoCurrentAction;
  public:   
    QueueList<ActionCollection*> SequenceToTake;
    
    boolean parsingInputCommands;
    
    boolean IsOverrideCurrentAction(){
     if( overrideCurrentAction ) {
       overrideCurrentAction = false;
       return true;
     }else{
       return false;
     }
    }
    boolean IsInsertIntoCurrentAction(){
     if( insertIntoCurrentAction ) {
       insertIntoCurrentAction = false;
       return true;
     }else{
       return false;
     }
    }
  
    //ActionCollection SequenceToTake;
    ActionSequence (){
      overrideCurrentAction = false;
      insertIntoCurrentAction = false;
      SequenceToTake = QueueList<ActionCollection*>();
    }
    ~ActionSequence(){
      while(!SequenceToTake.isEmpty()){
              delete SequenceToTake.pop();
            }
       //delete SequenceToTake;
    }
    
    
    void ParseActionSequence(String & serialStringInput){
        
    
    
    // ! : Do this now
    // @ : Loop do this // When you do this action collection, push it into a FIFO queue;
    // & : And do this Too
    // > : Then do this // Add to Sequence // Standard Action
      if(serialStringInput.length() > 0){
          
          boolean doThisNow = false;
          boolean loopThisSequence = false;
          boolean doThisToo = false;
                
          if(serialStringInput.charAt(0) == '!'){                
            doThisNow = true;
          }else if(serialStringInput.charAt(0) == '&'){
            doThisToo = true;
          }else if(serialStringInput.charAt(0) == '@'){
            loopThisSequence = true;
          }
          serialStringInput.setCharAt(0, '>');
          
    
          if(doThisNow){                
            while(!SequenceToTake.isEmpty()){
              SequenceToTake.pop();
            }
            overrideCurrentAction = true;
            
          }
          if(doThisToo){            
            insertIntoCurrentAction = true;
          }
          
          QueueList<String> SplitInput = Split(serialStringInput, '>');
          while (SplitInput.count() > 0){
            String valuevalue = SplitInput.pop();
            ActionCollection* actions = new ActionCollection();
            actions->Looping = loopThisSequence;
            actions->ParseActions(valuevalue);
            SequenceToTake.push(actions);
          } 
         
      }
    }
};
    
