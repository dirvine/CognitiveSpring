//
//  cSpringRobot.m
//  Arduino Serial Example
//
//  Created by Sean on 11/11/12.
//
//

#import "cSpringRobot.h"

@implementation cSpringRobot
@synthesize FinishedMoving, PowerOn, BatteryCurrent, BatteryVoltage, NumberOfActionsSequencesRemaining, NumberOfMusclesStillMoving, TimeTillAtGoal;
@synthesize LeftAnkleMuscleX, LeftAnkleMuscleZ, LeftHipMuscleX, LeftHipMuscleY, LeftHipMuscleZ, LeftKneeMuscleX;
@synthesize RightAnkleMuscleX, RightAnkleMuscleZ, RightHipMuscleX, RightHipMuscleY, RightHipMuscleZ, RightKneeMuscleX;
@synthesize LeftFootOrientationX, LeftFootOrientationZ, LeftShinOrientationX, LeftShinOrientationZ, LeftThighOrientationX, LeftThighOrientationZ;
@synthesize RightFootOrientationX, RightFootOrientationZ, RightShinOrientationX, RightShinOrientationZ, RightThighOrientationX, RightThighOrientationZ;
@synthesize TorsoOrientationX, TorsoOrientationZ;


-(id) initWithCommunications:(SerialNetworkingInterface *)communicationForRobot{
    [super init];
    
    cSpringSerialCommunication = communicationForRobot;
    
    
    
    return self;
}

-(NSString*) getSubString: (NSString*) body andKey:(NSString*) key{
    
    NSString* subBody = @"";
    
    @try {
        NSRange rangeFound;
        rangeFound = [body rangeOfString:key];
        
        int startLocation = rangeFound.location + rangeFound.length;
        rangeFound = [body rangeOfString:[NSString stringWithFormat:@"%@%@", @"/", key]];
        int endLocation = rangeFound.location;
        
        startLocation ++;
        endLocation --;
        
        NSRange subBodyRange;
        if(endLocation > startLocation){
            subBodyRange.location = startLocation;
            subBodyRange.length = endLocation - startLocation;
            
            
        
            subBody = [body substringWithRange:subBodyRange];
        }
    }
    @catch (NSException *exception) {
        int help = 0;
    }
 

    
    return subBody;
}

-(NSCalendar*) getTimeSpanFromMS: (int) miliseconds{
    return [[NSCalendar alloc] init];
}

/*
 
 <cSpring>
 <Status>
 <PowerOn>0</PowerOn>
 <FinishedMoving>1</FinishedMoving>
 <NumberOfMusclesStillMoving>0</NumberOfMusclesStillMoving>
 <TimeTillAtGoal>0</TimeTillAtGoal>
 <NumberOfActionsSequencesRemaining>0</NumberOfActionsSequencesRemaining>
 </Status>
 <Body>
 <LeftLeg>
 <Hip>
 <MuscleX><Position>55</Position> <Distance To Goal>0</Distance To Goal> </MuscleX>
 <MuscleY> <Position>70</Position> <Distance To Goal>0</Distance To Goal> </MuscleY>
 <MuscleZ> <Position>75</Position> <Distance To Goal>0</Distance To Goal> </MuscleZ>
 </Hip>
 <Knee>
 <MuscleX> <Position>75</Position> <Distance To Goal>0</Distance To Goal> </MuscleX>
 </Knee>
 <Ankle>
 <MuscleX> <Position>135</Position> <Distance To Goal>0</Distance To Goal> </MuscleX>
 <MuscleZ> <Position>110</Position> <Distance To Goal>0</Distance To Goal> </MuscleZ>
 </Ankle>
 </LeftLeg>
 <RightLeg>
 <Hip>
 <MuscleX><Position>125</Position><Distance To Goal>0</Distance To Goal></MuscleX>
 <MuscleY><Position>110</Position><Distance To Goal>0</Distance To Goal></MuscleY>
 <MuscleZ><Position>105</Position><Distance To Goal>0</Distance To Goal></MuscleZ>
 </Hip>
 <Knee>
 <MuscleX><Position>105</Position><Distance To Goal>0</Distance To Goal></MuscleX>
 </Knee>
 <Ankle>
 <MuscleX><Position>45</Position><Distance To Goal>0</Distance To Goal></MuscleX>
 <MuscleZ><Position>70</Position><Distance To Goal>0</Distance To Goal></MuscleZ>
 </Ankle>
 </RightLeg>
 </Body>
 </cSpring>
 
 */

-(void) ProcessSerialInput:(NSString *)robotInput{
    NSString* strPowerOn = [self getSubString:robotInput andKey:@"PowerOn"];
    NSString* strBatteryVoltage = [self getSubString:robotInput andKey:@"Voltage"];
    NSString* strBatteryCurrent = [self getSubString:robotInput andKey:@"Current"];
    NSString* strFinishedMoving = [self getSubString:robotInput andKey:@"FinishedMoving"];
    NSString* strNumberOfMusclesStillMoving = [self getSubString:robotInput andKey:@"NumberOfMusclesStillMoving"];
    NSString* strTimeTillAtGoal = [self getSubString:robotInput andKey:@"TimeTillAtGoal"];
    NSString* strNumberOfActionsSequencesRemaining = [self getSubString:robotInput andKey:@"NumberOfActionsSequencesRemaining"];
    
    
    NSString* strTorso = [self getSubString:robotInput andKey:@"Torso"];
    
    TorsoOrientationX = [[self getSubString:strTorso andKey:@"OrientationX"] doubleValue];
    TorsoOrientationZ = [[self getSubString:strTorso andKey:@"OrientationZ"] doubleValue];
    
    NSString* strLeftLeg = [self getSubString:robotInput andKey:@"LeftLeg"];
    NSString* strRightLeg = [self getSubString:robotInput andKey:@"RightLeg"];
    
    //Left Leg
    if(![strLeftLeg isEqualToString:@""]){
        NSString* strHip = [self getSubString:strLeftLeg andKey:@"Hip"];
        NSString* strKnee = [self getSubString:strLeftLeg andKey:@"Knee"];
        NSString* strAnkle = [self getSubString:strLeftLeg andKey:@"Ankle"];
        NSString* strFoot = [self getSubString:strLeftLeg andKey:@"Foot"];
        NSString* strShin = [self getSubString:strLeftLeg andKey:@"Shin"];
        NSString* strThigh = [self getSubString:strLeftLeg andKey:@"Thigh"];
        
        
        LeftHipMuscleX = [[self getSubString:[self getSubString:strHip andKey:@"MuscleX"] andKey:@"Position"] doubleValue];
        LeftHipMuscleY = [[self getSubString:[self getSubString:strHip andKey:@"MuscleY"] andKey:@"Position"] doubleValue];
        LeftHipMuscleZ = [[self getSubString:[self getSubString:strHip andKey:@"MuscleZ"] andKey:@"Position"] doubleValue];
        
        LeftThighOrientationX = [[self getSubString:strThigh andKey:@"OrientationX"] doubleValue];
        LeftThighOrientationZ = [[self getSubString:strThigh andKey:@"OrientationZ"] doubleValue];
        
        LeftKneeMuscleX = [[self getSubString:[self getSubString:strKnee andKey:@"MuscleX"] andKey:@"Position"] doubleValue];
        
        LeftShinOrientationX = [[self getSubString:strShin andKey:@"OrientationX"]doubleValue];
        LeftShinOrientationZ = [[self getSubString:strShin andKey:@"OrientationZ"]doubleValue];
        
        LeftAnkleMuscleX = [[self getSubString:[self getSubString:strAnkle andKey:@"MuscleX"] andKey:@"Position"] doubleValue];
        LeftAnkleMuscleZ = [[self getSubString:[self getSubString:strAnkle andKey:@"MuscleZ"] andKey:@"Position"] doubleValue];
        
        LeftFootOrientationX = [[self getSubString:strFoot andKey:@"OrientationX"] doubleValue];
        LeftFootOrientationZ = [[self getSubString:strFoot andKey:@"OrientationZ"] doubleValue];
    }
    
    //Right Leg
    if(![strRightLeg isEqualToString:@""]){
        NSString* strHip = [self getSubString:strRightLeg andKey:@"Hip"];
        NSString* strKnee = [self getSubString:strRightLeg andKey:@"Knee"];
        NSString* strAnkle = [self getSubString:strRightLeg andKey:@"Ankle"];
        NSString* strFoot = [self getSubString:strRightLeg andKey:@"Foot"];
        NSString* strShin = [self getSubString:strRightLeg andKey:@"Shin"];
        NSString* strThigh = [self getSubString:strRightLeg andKey:@"Thigh"];
        
        RightHipMuscleX = [[self getSubString:[self getSubString:strHip andKey:@"MuscleX"] andKey:@"Position"] doubleValue];
        RightHipMuscleY = [[self getSubString:[self getSubString:strHip andKey:@"MuscleY"] andKey:@"Position"] doubleValue];
        RightHipMuscleZ = [[self getSubString:[self getSubString:strHip andKey:@"MuscleZ"] andKey:@"Position"] doubleValue];
        
        RightThighOrientationX = [[self getSubString:strThigh andKey:@"OrientationX"] doubleValue];
        RightThighOrientationZ = [[self getSubString:strThigh andKey:@"OrientationZ"] doubleValue];
        
        RightKneeMuscleX = [[self getSubString:[self getSubString:strKnee andKey:@"MuscleX"] andKey:@"Position"] doubleValue];
        
        RightShinOrientationX = [[self getSubString:strShin andKey:@"OrientationX"]doubleValue];
        RightShinOrientationZ = [[self getSubString:strShin andKey:@"OrientationZ"]doubleValue];
        
        RightAnkleMuscleX = [[self getSubString:[self getSubString:strAnkle andKey:@"MuscleX"] andKey:@"Position"] doubleValue];
        RightAnkleMuscleZ = [[self getSubString:[self getSubString:strAnkle andKey:@"MuscleZ"] andKey:@"Position"] doubleValue];
        
        RightFootOrientationX = [[self getSubString:strFoot andKey:@"OrientationX"] doubleValue];
        RightFootOrientationZ = [[self getSubString:strFoot andKey:@"OrientationZ"] doubleValue];
    }
    
    //
    //    NSData *xmlData = [NSData dataWithContentsOfFile:robotInput];
    //    parser = [[[NSXMLParser alloc] initWithData:xmlData] autorelease];
    //    [parser setDelegate:self];
    //    [parser parse];
    //[parser dealloc];
    
    
    PowerOn = [[NSNumber numberWithInt:[strPowerOn integerValue]] boolValue];
    BatteryCurrent = [strBatteryCurrent integerValue];
    BatteryVoltage = [strBatteryVoltage integerValue];
    FinishedMoving = [[NSNumber numberWithInt:[strFinishedMoving integerValue]] boolValue];
    NumberOfActionsSequencesRemaining = [strNumberOfActionsSequencesRemaining integerValue];
    NumberOfMusclesStillMoving = [strNumberOfMusclesStillMoving integerValue];
    TimeTillAtGoal = [strTimeTillAtGoal integerValue];
    
    
}

-(NSString*) WriteNewPose:(Pose*) poseToWrite{
    
    NSMutableString * command = [[NSMutableString alloc] init];
    
    [command appendString:[NSString stringWithFormat:@"Left.Ankle.MuscleX.SetNewGoal,%@,%@&", [poseToWrite LeftAnkleX], [poseToWrite TimeMSToImplementPose]]];
    [command appendString:[NSString stringWithFormat:@"Left.Ankle.MuscleZ.SetNewGoal,%@,%@&", [poseToWrite LeftAnkleZ], [poseToWrite TimeMSToImplementPose]]];
    [command appendString:[NSString stringWithFormat:@"Left.Hip.MuscleX.SetNewGoal,%@,%@&", [poseToWrite LeftHipX], [poseToWrite TimeMSToImplementPose]]];
    [command appendString:[NSString stringWithFormat:@"Left.Hip.MuscleY.SetNewGoal,%@,%@&", [poseToWrite LeftHipY], [poseToWrite TimeMSToImplementPose]]];
    [command appendString:[NSString stringWithFormat:@"Left.Hip.MuscleZ.SetNewGoal,%@,%@&", [poseToWrite LeftHipZ], [poseToWrite TimeMSToImplementPose]]];
    [command appendString:[NSString stringWithFormat:@"Left.Knee.MuscleX.SetNewGoal,%@,%@&", [poseToWrite LeftKneeX], [poseToWrite TimeMSToImplementPose]]];
    
    [command appendString:[NSString stringWithFormat:@"Right.Ankle.MuscleX.SetNewGoal,%@,%@&", [poseToWrite RightAnkleX], [poseToWrite TimeMSToImplementPose]]];
    [command appendString:[NSString stringWithFormat:@"Right.Ankle.MuscleZ.SetNewGoal,%@,%@&", [poseToWrite RightAnkleZ], [poseToWrite TimeMSToImplementPose]]];
    [command appendString:[NSString stringWithFormat:@"Right.Hip.MuscleX.SetNewGoal,%@,%@&", [poseToWrite RightHipX], [poseToWrite TimeMSToImplementPose]]];
    [command appendString:[NSString stringWithFormat:@"Right.Hip.MuscleY.SetNewGoal,%@,%@&", [poseToWrite RightHipY], [poseToWrite TimeMSToImplementPose]]];
    [command appendString:[NSString stringWithFormat:@"Right.Hip.MuscleZ.SetNewGoal,%@,%@&", [poseToWrite RightHipZ], [poseToWrite TimeMSToImplementPose]]];
    [command appendString:[NSString stringWithFormat:@"Right.Knee.MuscleX.SetNewGoal,%@,%@", [poseToWrite RightKneeX], [poseToWrite TimeMSToImplementPose]]];
       return command;
}




@end
