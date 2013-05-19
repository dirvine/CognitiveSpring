

//
//  Pose.m
//  cSpring Control Center
//
//  Created by Sean on 1/9/13.
//
//

#import "Pose.h"

@implementation Pose
@synthesize NameOfPose,LeftAnkleX,LeftAnkleZ,LeftHipX,LeftHipY,LeftHipZ,LeftKneeX,RightAnkleX,RightAnkleZ,RightHipX,RightHipY,RightHipZ,RightKneeX, TimeMSToImplementPose;

+(Pose*) StaticStand:(int) duration{
    Pose* newPose = [[Pose alloc]init];
    
    newPose.NameOfPose = @"Stand";
    newPose.TimeMSToImplementPose = [[NSNumber alloc] initWithInt: duration];
    newPose.LeftAnkleX = [[NSNumber alloc] initWithInt: 79];
    newPose.LeftAnkleZ = [[NSNumber alloc] initWithInt: 84];
    
    newPose.LeftKneeX = [[NSNumber alloc] initWithInt: 175];
    
    newPose.LeftHipX = [[NSNumber alloc] initWithInt: 60];
    newPose.LeftHipY = [[NSNumber alloc] initWithInt: 70];
    newPose.LeftHipZ = [[NSNumber alloc] initWithInt: 65];
    
    newPose.RightAnkleX = [[NSNumber alloc] initWithInt: 79];
    newPose.RightAnkleZ = [[NSNumber alloc] initWithInt: 84];
    
    newPose.RightKneeX = [[NSNumber alloc] initWithInt: 175];
    
    newPose.RightHipX = [[NSNumber alloc] initWithInt: 60];
    newPose.RightHipY = [[NSNumber alloc] initWithInt: 70];
    newPose.RightHipZ = [[NSNumber alloc] initWithInt: 65];
    
    return newPose;
}

+(Pose*) StaticSquat:(int) duration{
    
    Pose* newPose = [[Pose alloc]init];
    
    newPose.NameOfPose = @"Squat";
    newPose.TimeMSToImplementPose = [[NSNumber alloc] initWithInt: duration];
    newPose.LeftAnkleX = [[NSNumber alloc] initWithInt: 57];
    newPose.LeftAnkleZ = [[NSNumber alloc] initWithInt: 92];
    
    newPose.LeftKneeX = [[NSNumber alloc] initWithInt: 39];
    
    newPose.LeftHipX = [[NSNumber alloc] initWithInt: 90];
    newPose.LeftHipY = [[NSNumber alloc] initWithInt: 70];
    newPose.LeftHipZ = [[NSNumber alloc] initWithInt: 75];
    
    newPose.RightAnkleX = [[NSNumber alloc] initWithInt: 57];
    newPose.RightAnkleZ = [[NSNumber alloc] initWithInt: 92];
    
    newPose.RightKneeX = [[NSNumber alloc] initWithInt: 39];
    
    newPose.RightHipX = [[NSNumber alloc] initWithInt: 90];
    newPose.RightHipY = [[NSNumber alloc] initWithInt: 70];
    newPose.RightHipZ = [[NSNumber alloc] initWithInt: 75];
    
    return newPose;
}



- (void) encodeWithCoder: (NSCoder *)coder
{
    //NameOfPose,AnkleX,AnkleZ,KneeX,HipX,HipY,HipZ, TimeMSToImplementPose;
    if(NameOfPose != @""){
        [coder encodeObject:self.NameOfPose forKey:@"NameOfPose"];
        [coder encodeObject:self.TimeMSToImplementPose forKey:@"TimeMSToImplementPose"];
        [coder encodeObject:self.LeftAnkleX forKey:@"LeftAnkleX"];
        [coder encodeObject:self.LeftAnkleZ forKey:@"LeftAnkleZ"];
        [coder encodeObject:self.LeftKneeX forKey:@"LeftKneeX"];
        [coder encodeObject:self.LeftHipX forKey:@"LeftHipX"];
        [coder encodeObject:self.LeftHipY forKey:@"LeftHipY"];
        [coder encodeObject:self.LeftHipZ forKey:@"LeftHipZ"];
        
        [coder encodeObject:self.RightAnkleX forKey:@"RightAnkleX"];
        [coder encodeObject:self.RightAnkleZ forKey:@"RightAnkleZ"];
        [coder encodeObject:self.RightKneeX forKey:@"RightKneeX"];
        [coder encodeObject:self.RightHipX forKey:@"RightHipX"];
        [coder encodeObject:self.RightHipY forKey:@"RightHipY"];
        [coder encodeObject:self.RightHipZ forKey:@"RightHipZ"];
    }
}
- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        //NameOfPose,AnkleX,AnkleZ,KneeX,HipX,HipY,HipZ, TimeMSToImplementPose;
        self.NameOfPose = [coder decodeObjectForKey:@"NameOfPose"];
        self.TimeMSToImplementPose = [coder decodeObjectForKey:@"TimeMSToImplementPose"];
        self.LeftAnkleX = [coder decodeObjectForKey:@"LeftAnkleX"];
        self.LeftAnkleZ = [coder decodeObjectForKey:@"LeftAnkleZ"];
        self.LeftKneeX = [coder decodeObjectForKey:@"LeftKneeX"];
        self.LeftHipX = [coder decodeObjectForKey:@"LeftHipX"];
        self.LeftHipY = [coder decodeObjectForKey:@"LeftHipY"];
        self.LeftHipZ = [coder decodeObjectForKey:@"LeftHipZ"];
        
        self.RightAnkleX = [coder decodeObjectForKey:@"RightAnkleX"];
        self.RightAnkleZ = [coder decodeObjectForKey:@"RightAnkleZ"];
        self.RightKneeX = [coder decodeObjectForKey:@"RightKneeX"];
        self.RightHipX = [coder decodeObjectForKey:@"RightHipX"];
        self.RightHipY = [coder decodeObjectForKey:@"RightHipY"];
        self.RightHipZ = [coder decodeObjectForKey:@"RightHipZ"];
    }
    return self;
}

@end



@implementation Poses
 
-(id) init{
    [super init];
    //savedPoses = [[NSMutableDictionary alloc]init];
    
    NSData *savedPosesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedPosesData"];
    savedPoses = [[NSMutableDictionary alloc] initWithDictionary:[[NSKeyedUnarchiver unarchiveObjectWithData:savedPosesData] mutableCopy]];
    
    // [self addPose:[Pose StaticSquat:4000]];
    // [self addPose:[Pose StaticStand:4000]];
    //[savedPoses setObject:[Pose StaticStand:4000] forKey:[[Pose StaticStand:4000].NameOfPose uppercaseString]];

    
    return self;
}

-(void) addPose:(Pose *)newPose{
    if(savedPoses == nil){
        savedPoses = [[NSMutableDictionary alloc]init];
    }
    
    [savedPoses setObject:newPose forKey:[newPose.NameOfPose uppercaseString]];
    
    NSData *savedPosesData = [NSKeyedArchiver archivedDataWithRootObject:savedPoses]; // archivedDataWithRootObject:savedPoses];
    [[NSUserDefaults standardUserDefaults] setObject:savedPosesData forKey:@"savedPosesData"];
}

-(Pose*) searchForPoseByName:(NSString*) poseName{
    
    return [savedPoses objectForKey:[poseName uppercaseString]];
}

-(Pose*) removePoseByName:(NSString*) poseName{
    
    if(savedPoses == nil){
        savedPoses = [[NSMutableDictionary alloc]init];
    }
    
    [savedPoses removeObjectForKey:poseName];
    
    NSData *savedPosesData = [NSKeyedArchiver archivedDataWithRootObject:savedPoses]; // archivedDataWithRootObject:savedPoses];
    [[NSUserDefaults standardUserDefaults] setObject:savedPosesData forKey:@"savedPosesData"];
}


-(NSArray*) listAllPoses{
    
    return [[ NSArray alloc] initWithArray: [savedPoses allKeys]];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[self listAllPoses] count];
}

@end





