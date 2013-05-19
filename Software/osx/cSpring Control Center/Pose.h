//
//  Pose.h
//  cSpring Control Center
//
//  Created by Sean on 1/9/13.
//
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface Pose : NSObject<NSCoding>
@property (retain) NSString* NameOfPose;
@property (retain) NSNumber* RightAnkleX;
@property (retain) NSNumber* RightAnkleZ;
@property (retain) NSNumber* RightKneeX;
@property (retain) NSNumber* RightHipX;
@property (retain) NSNumber* RightHipY;
@property (retain) NSNumber* RightHipZ;
@property (retain) NSNumber* LeftAnkleX;
@property (retain) NSNumber* LeftAnkleZ;
@property (retain) NSNumber* LeftKneeX;
@property (retain) NSNumber* LeftHipX;
@property (retain) NSNumber* LeftHipY;
@property (retain) NSNumber* LeftHipZ;
@property (retain) NSNumber* TimeMSToImplementPose;

+(Pose*) StaticStandIn:(int) msDuration;
+(Pose*) StaticSquat:(int) msDuration;





@end


@interface Poses : NSObject<NSTableViewDataSource>
{
    NSMutableDictionary* savedPoses;
}

-(id) init;
-(void) addPose:(Pose*) newPose;
-(Pose*) searchForPoseByName:(NSString*) poseName;
-(Pose*) removePoseByName:(NSString*) poseName;
-(NSArray*) listAllPoses;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
@end