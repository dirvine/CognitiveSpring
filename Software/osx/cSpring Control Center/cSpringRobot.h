//
//  cSpringRobot.h
//  Arduino Serial Example
//
//  Created by Sean on 11/11/12.
//
//

#import <Foundation/Foundation.h>
#import "Pose.h"

#ifndef cSpringRobot_Class
#define cSpringRobot_Class

@class SerialNetworkingInterface;

@interface cSpringRobot : NSObject <NSXMLParserDelegate>{
    SerialNetworkingInterface* cSpringSerialCommunication;
}

@property (nonatomic) bool PowerOn;
@property (nonatomic) int BatteryCurrent;
@property (nonatomic) int BatteryVoltage;
@property (nonatomic) bool FinishedMoving;
@property (nonatomic) int TimeTillAtGoal;
@property (nonatomic) int NumberOfMusclesStillMoving;
@property (nonatomic) int NumberOfActionsSequencesRemaining;

@property (nonatomic) double TorsoOrientationX;
@property (nonatomic) double TorsoOrientationZ;

@property (nonatomic) double LeftHipMuscleX;
@property (nonatomic) double LeftHipMuscleY;
@property (nonatomic) double LeftHipMuscleZ;
@property (nonatomic) double RightHipMuscleX;
@property (nonatomic) double RightHipMuscleY;
@property (nonatomic) double RightHipMuscleZ;

@property (nonatomic) double LeftThighOrientationX;
@property (nonatomic) double LeftThighOrientationZ;
@property (nonatomic) double RightThighOrientationX;
@property (nonatomic) double RightThighOrientationZ;

@property (nonatomic) double LeftKneeMuscleX;
@property (nonatomic) double RightKneeMuscleX;

@property (nonatomic) double LeftShinOrientationX;
@property (nonatomic) double LeftShinOrientationZ;
@property (nonatomic) double RightShinOrientationX;
@property (nonatomic) double RightShinOrientationZ;

@property (nonatomic) double LeftAnkleMuscleX;
@property (nonatomic) double LeftAnkleMuscleZ;
@property (nonatomic) double RightAnkleMuscleX;
@property (nonatomic) double RightAnkleMuscleZ;

@property (nonatomic) double LeftFootOrientationX;
@property (nonatomic) double LeftFootOrientationZ;
@property (nonatomic) double RightFootOrientationX;
@property (nonatomic) double RightFootOrientationZ;

-(id) initWithCommunications:(SerialNetworkingInterface*) communicationForRobot;

-(NSString*) getSubString: (NSString*) body andKey:(NSString*) key;
-(void) ProcessSerialInput: (NSString*) robotInput;
-(void) SendSerialOutputOfCurrentPose;

-(NSString*) WriteNewPose:(Pose*) poseToWrite;


@end

#endif
