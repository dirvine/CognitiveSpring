//
//  SerialExample.m
//  Arduino Serial Example
//
//  Created by Gabe Ghearing on 6/30/09.
//

#import "SerialExample.h"


@implementation SerialExample
@synthesize scvSavedActions;
@synthesize inputBuffer;
@synthesize tblSavedPoses;

// executes after everything in the xib/nib is initiallized
- (void)awakeFromNib {
    
    
    cSpringPoses = [[Poses alloc]init];
    tblSavedPoses.delegate = self;
    tblSavedPoses.dataSource = self;
    
    
	// we don't have a serial port open yet
    inputBuffer = [[NSMutableString alloc]init];
    cSpringSerial = [[SerialNetworkingInterface alloc] initWithDisplay:self];
    
	// first thing is to refresh the serial port list
    //	[self refreshSerialList:@"Select a Serial Port"];
	// now put the cursor in the text field
    devcSpring = [[cSpringRobot alloc]initWithCommunications:cSpringSerial];
    
    [serialInputField becomeFirstResponder];
    [self writecSpringSensorPose];
    
    
    serialInputField.delegate = self;
    
    [niDisplay setCanDrawConcurrently:YES];
    // [self displayCSpringPoses];
    
    // [tblSavedPoses reloadData];
    
    [self refreshSerialList:@"Select Port"];
    // [self performSelector:@selector(refreshSerialList:) withObject:nil afterDelay:10];
    [self serialPortSelected:nil];

    
    
    }

-(id) init{
    
    
    return self;
}

-(void) drawAccelerometers{
    
//    CGContextRef contextRef = [oglBodyOrientation g//UIGraphicsGetCurrentContext();
//    
//    CGContextSetRGBFillColor(contextRef, 0, 0, 255, 0.1);
//    CGContextSetRGBStrokeColor(contextRef, 0, 0, 255, 0.5);
//    
//    // Draw a circle (filled)
//    CGContextFillEllipseInRect(contextRef, CGRectMake(100, 100, 25, 25));
//    
//    // Draw a circle (border only)
//    CGContextStrokeEllipseInRect(contextRef, CGRectMake(100, 100, 25, 25));
//
//    // Get the graphics context and clear it
////    CGContextRef ctx = UIGraphicsGetCurrentContext();
////    //CGContextClearRect(ctx, rect);
////    
////    // Draw a green solid circle
////    CGContextSetRGBFillColor(ctx, 0, 255, 0, 1);
////    CGContextFillEllipseInRect(ctx, CGRectMake(100, 100, 25, 25));
////    
////    // Draw a yellow hollow rectangle
////    CGContextSetRGBStrokeColor(ctx, 255, 255, 0, 1);
////    CGContextStrokeRect(ctx, CGRectMake(195, 195, 60, 60));
////    
////    // Draw a purple triangle with using lines
////    CGContextSetRGBStrokeColor(ctx, 255, 0, 255, 1);
////    CGPoint points[6] = { CGPointMake(100, 200), CGPointMake(150, 250),
////        CGPointMake(150, 250), CGPointMake(50, 250),
////        CGPointMake(50, 250), CGPointMake(100, 200) };
//    CGContextStrokeLineSegments(ctx, points, 6);

}
// updates the textarea for incoming text by appending text
- (void)appendToIncomingText: (NSString*) text {
    
	NSAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: text];
    
//	NSTextStorage *textStorage = [serialOutputArea textStorage];
//	[textStorage beginEditing];
//	[textStorage appendAttributedString:attrString];
//	[textStorage endEditing];
//	[attrString release];
//	
//	// scroll to the bottom
//	NSRange myRange;
//	myRange.length = 1;
//	myRange.location = [textStorage length];
//	[serialOutputArea scrollRangeToVisible:myRange];
    
    
        if([text rangeOfString:@"</cSpring>"].length > 0){
            [devcSpring ProcessSerialInput:text];
            [self displaycSpringStatus];
            [self writecSpringPose];
            [self writecSpringSensorPose];
            
        }else{
            
            NSAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: text];
            //[inputBuffer appendString:[NSString stringWithString:[attrString string]]];
            
            NSTextStorage *textStorage = [serialOutputFiltered textStorage];
            [textStorage beginEditing];
            [textStorage appendAttributedString:attrString];
            [textStorage endEditing];
            [attrString release];
            
            // scroll to the bottom
            NSRange myRange;
            myRange.length = 1;
            myRange.location = [textStorage length];
            [serialOutputFiltered scrollRangeToVisible:myRange];
        }
        

    

    
}

- (IBAction)control:(id)sender {
    
}

- (IBAction)voidcontrolTextDidEndEditingNSNotificationnotificationSeeifitwasduetoareturnifnotificationuserInfoobjectForKeyNSTextMovementintValueNSReturnTextMovementNSLogReturnwaspressedtextDidChange:(NSTextField *)sender {
}


- (IBAction)clearSerial:(id)sender {
    [serialInputField setStringValue:@""];
}

- (void) refreshSerialList: (NSString *) selectedText {
    @try{
        //readThreadRunning = FALSE;
        io_object_t serialPort;
        io_iterator_t serialPortIterator;
        NSString* titleOfSerialPorts;
        NSString* titleOfUSB = selectedText;
        // remove everything from the pull down list
        [serialListPullDown removeAllItems];
        
        // ask for all the serial ports
        IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching(kIOSerialBSDServiceValue), &serialPortIterator);
        
        // loop through all the serial ports and add them to the array
        while (serialPort = IOIteratorNext(serialPortIterator)) {
            titleOfSerialPorts = (NSString*)IORegistryEntryCreateCFProperty(serialPort, CFSTR(kIOCalloutDeviceKey),  kCFAllocatorDefault, 0);

            [serialListPullDown addItemWithTitle:titleOfSerialPorts];
            IOObjectRelease(serialPort);
            if([titleOfSerialPorts rangeOfString:@"usb"].length > 0){
                titleOfUSB = titleOfSerialPorts;
            }
        }
        

        if([titleOfUSB isEqualToString:selectedText]){
        // add the selected text to the top
            [serialListPullDown insertItemWithTitle:selectedText atIndex:0];
            [serialListPullDown selectItemWithTitle:titleOfUSB];
        }else{
            [serialListPullDown selectItemWithTitle:titleOfUSB];
          //  [self serialPortSelected:nil];
        }
    //	[serialListPullDown setEnabled:YES];
        IOObjectRelease(serialPortIterator);
    }@catch (NSException* e) {
        
    }
}
// action sent when serial port selected
- (IBAction) serialPortSelected: (id) cntrl {
	@try {
        
        //readThreadRunning = FALSE;
    // open the serial port
       // NSString *error = [cSpringSerial openSerialPort: [serialListPullDown titleOfSelectedItem] baud:(speed_t)[baudInputField intValue]];
        
        speed_t baud = ((speed_t)[baudInputField integerValue]);
        NSString* port = [serialListPullDown titleOfSelectedItem];
        
        NSString* error = [cSpringSerial openSerialPort:port baud:baud];
        
        int tries = 3;
        
        while (error != nil && tries > 0){
            error = [cSpringSerial openSerialPort:port baud:baud];
            tries --;
        }
        
        if(error!=nil) {
            [self refreshSerialList:error];
            [self appendToIncomingText:error];
        } else {
            if(cntrl != nil){
                [self refreshSerialList:[serialListPullDown titleOfSelectedItem]];
            }
        }
    }@catch (NSException* e) {
        
    }
        
    
}

// action from baud rate change
- (IBAction) baudAction: (id) cntrl {
		[cSpringSerial SetBaud:[baudInputField intValue]];
}

// action from refresh button 
- (IBAction) refreshAction: (id) cntrl {
    @try{
        [self refreshSerialList:@"Select a Serial Port"];
	
        [cSpringSerial closeSerial];
        
    }@catch (NSException* e) {
        
    }
}

// action from send button and on return in the text field
- (IBAction) sendText: (id) cntrl {
	// send the text to the Arduino
	[self writeString:[serialInputField stringValue]];
	
	// blank the field
	[serialInputField setStringValue:@""];
}

// action from send button and on return in the text field
- (IBAction) sliderChange: (NSSlider *) sldr {
	uint8_t val = [sldr intValue];
	[self writeByte:&val];
}


- (IBAction) hitAnActionButton: (NSButton *) btn {
    NSString* command = [[[btn title] stringByReplacingOccurrencesOfString:@"'" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([[[bxLeft contentView] subviews] containsObject:btn]){
        command = [NSString stringWithFormat:@"%@%@", @"left.", command];
    }
    if([[[bxRight  contentView] subviews] containsObject:btn]){
        command = [NSString stringWithFormat:@"%@%@", @"right.", command];
    }
    
    NSString* distanceAndTime = @"";
    if(!([[command lowercaseString] isEqualToString: @"on"]||
         [[command lowercaseString] isEqualToString: @"off"]||
         [[command lowercaseString] isEqualToString: @"then"])){
        distanceAndTime = [NSString stringWithFormat:@"%@%@%@%@", @",", [txtDistanceValue stringValue], @",", [txtTimeValue stringValue]];
    }
    if([command isEqualToString:@"THEN"]){
        command = @">";
    }
    if (![[serialInputField stringValue] isEqualToString:@""]) {
        
        if([[serialInputField stringValue] characterAtIndex:[[serialInputField stringValue] length] -1] == '>' || [command isEqualToString:@">"]){
            command = [NSString stringWithFormat:@"%@%@", [serialInputField stringValue], command];
        }else if([chkAutoSend state] != 1){
            
            command = [NSString stringWithFormat:@"%@%@%@", [serialInputField stringValue], @"&", command];
        }
        
    }
    
    command = [NSString stringWithFormat:@"%@%@", command, distanceAndTime];
    
    [serialInputField setStringValue:command];
    if([chkAutoSend state] == 1){
        [self writeString:[serialInputField stringValue]];
        //[serialInputField setStringValue:@""];
    }
   // [serialInputField becomeFirstResponder];
}


- (IBAction)changedAPoseSlider:(id)sender {
    NSString* command = [[[sender toolTip] stringByReplacingOccurrencesOfString:@"'" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString* distanceAndTime = @"";
    if(!(
         [[command lowercaseString] isEqualToString: @"on"]||
         [[command lowercaseString] isEqualToString: @"off"]||
         [[command lowercaseString] isEqualToString: @"then"])){
        distanceAndTime = [NSString stringWithFormat:@"%@%li%@%@", @",", [sender integerValue], @",", [txtTimeValue stringValue]];
    }
    
    if([command isEqualToString:@"THEN"]){
        command = @">";
    }
    
    if(![[serialInputField stringValue] isEqualToString:@""]){
        command = [NSString stringWithFormat:@"%@&%@", [serialInputField stringValue], command];
    }
    command = [NSString stringWithFormat:@"%@%@%@", command, @".SetNewGoal", distanceAndTime];
    [serialInputField setStringValue:command];
    if([chkAutoSend state] == 1){
        [self writeString:[serialInputField stringValue]];
        //[serialInputField setStringValue:@""];
    }
    //[serialInputField becomeFirstResponder];
}


- (IBAction)btnHitAPoseButton:(id)sender {
  
    [self runPoseByName:[sender title]];
    
}

-(void) runPoseByName:(NSString*) poseName{
    NSString* command = [[poseName stringByReplacingOccurrencesOfString:@"'" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    Pose* thePose = [cSpringPoses searchForPoseByName:command];
    
    if(thePose != nil){
        thePose.TimeMSToImplementPose = [NSNumber numberWithInteger:[txtTimeValue integerValue]];
        command = [devcSpring WriteNewPose:thePose];
        [txtPoseName setStringValue:thePose.NameOfPose];
        //command = [NSString stringWithFormat:@"%@%@%@", command, @",0,", [txtTimePoseValue stringValue]];
    }
    
    if([command isEqualToString:@"THEN"]){
        command = @">";
    }
    
    
    [serialInputField setStringValue:command];
    if([chkAutoSend state] == 1){
        [self writeString:[serialInputField stringValue]];
        //[serialInputField setStringValue:@""];
    }
    //[serialInputField becomeFirstResponder];
    

}
- (IBAction)btnSavePoseCommand:(id)sender {
    Pose* newPose = [[Pose alloc] init];
    newPose.NameOfPose = [txtPoseName stringValue];
    newPose.TimeMSToImplementPose = [NSNumber numberWithInteger:[txtTimeValue integerValue]];
    newPose.LeftAnkleX = [NSNumber numberWithInteger:vsLeftAnkleX.integerValue];
    newPose.LeftAnkleZ = [NSNumber numberWithInteger:vsLeftAnkleZ.integerValue];
    newPose.LeftHipX = [NSNumber numberWithInteger:vsLeftHipX.integerValue];
    newPose.LeftHipY = [NSNumber numberWithInteger:vsLeftHipY.integerValue];
    newPose.LeftHipZ = [NSNumber numberWithInteger:vsLeftHipZ.integerValue];
    newPose.LeftKneeX = [NSNumber numberWithInteger:vsLeftKneeX.integerValue];
    newPose.RightAnkleX = [NSNumber numberWithInteger:vsRightAnkleX.integerValue];
    newPose.RightAnkleZ = [NSNumber numberWithInteger:vsRightAnkleZ.integerValue];
    newPose.RightHipX = [NSNumber numberWithInteger:vsRightHipX.integerValue];
    newPose.RightHipY = [NSNumber numberWithInteger:vsRightHipY.integerValue];
    newPose.RightHipZ = [NSNumber numberWithInteger:vsRightHipZ.integerValue];
    newPose.RightKneeX = [NSNumber numberWithInteger:vsRightKneeX.integerValue];
    
    
    [cSpringPoses addPose:newPose];
    [tblSavedPoses reloadData];
    //[newPose release];
}

- (IBAction)btnCopyRightToLeft:(id)sender {
    
    NSString* command = @"left.hip.musclex.setnewgoal";
    NSString* distanceAndTime = [NSString stringWithFormat:@"%@%li%@%@", @",", [vsRightHipX integerValue], @",", [txtTimeValue stringValue]];
    
    command = [NSString stringWithFormat:@"%@%@%@", command, distanceAndTime, @"&left.hip.muscley.setnewgoal"];
    distanceAndTime = [NSString stringWithFormat:@"%@%li%@%@", @",", [vsRightHipY integerValue], @",", [txtTimeValue stringValue]];
    
    command = [NSString stringWithFormat:@"%@%@%@", command, distanceAndTime, @"&left.hip.musclez.setnewgoal"];
    distanceAndTime = [NSString stringWithFormat:@"%@%li%@%@", @",", [vsRightHipZ integerValue], @",", [txtTimeValue stringValue]];
    
    command = [NSString stringWithFormat:@"%@%@%@", command, distanceAndTime, @"&left.knee.musclex.setnewgoal"];
    distanceAndTime = [NSString stringWithFormat:@"%@%li%@%@", @",", [vsRightKneeX integerValue], @",", [txtTimeValue stringValue]];
    
    command = [NSString stringWithFormat:@"%@%@%@", command, distanceAndTime, @"&left.ankle.musclex.setnewgoal"];
    distanceAndTime = [NSString stringWithFormat:@"%@%li%@%@", @",", [vsRightAnkleX integerValue], @",", [txtTimeValue stringValue]];
    
    command = [NSString stringWithFormat:@"%@%@%@", command, distanceAndTime, @"&left.ankle.musclez.setnewgoal"];
    distanceAndTime = [NSString stringWithFormat:@"%@%li%@%@", @",", [vsRightAnkleZ integerValue], @",", [txtTimeValue stringValue]];
    
    command = [NSString stringWithFormat:@"%@%@", command, distanceAndTime];
    

    
    [serialInputField setStringValue:command];
    if([chkAutoSend state] == 1){
        [self writeString:[serialInputField stringValue]];
        //[serialInputField setStringValue:@""];
    }

    
}

- (IBAction)btnCopyLeftToRight:(id)sender {
    
    
    NSString* command = @"right.hip.musclex.setnewgoal";
    NSString* distanceAndTime = [NSString stringWithFormat:@"%@%li%@%@", @",", [vsLeftHipX integerValue], @",", [txtTimeValue stringValue]];
    
    command = [NSString stringWithFormat:@"%@%@%@", command, distanceAndTime, @"&right.hip.muscley.setnewgoal"];
    distanceAndTime = [NSString stringWithFormat:@"%@%li%@%@", @",", [vsLeftHipY integerValue], @",", [txtTimeValue stringValue]];
    
    command = [NSString stringWithFormat:@"%@%@%@", command, distanceAndTime, @"&right.hip.musclez.setnewgoal"];
    distanceAndTime = [NSString stringWithFormat:@"%@%li%@%@", @",", [vsLeftHipZ integerValue], @",", [txtTimeValue stringValue]];
    
    command = [NSString stringWithFormat:@"%@%@%@", command, distanceAndTime, @"&right.knee.musclex.setnewgoal"];
    distanceAndTime = [NSString stringWithFormat:@"%@%li%@%@", @",", [vsLeftKneeX integerValue], @",", [txtTimeValue stringValue]];
    
    command = [NSString stringWithFormat:@"%@%@%@", command, distanceAndTime, @"&right.ankle.musclex.setnewgoal"];
    distanceAndTime = [NSString stringWithFormat:@"%@%li%@%@", @",", [vsLeftAnkleX integerValue], @",", [txtTimeValue stringValue]];
    
    command = [NSString stringWithFormat:@"%@%@%@", command, distanceAndTime, @"&right.ankle.musclez.setnewgoal"];
    distanceAndTime = [NSString stringWithFormat:@"%@%li%@%@", @",", [vsLeftAnkleZ integerValue], @",", [txtTimeValue stringValue]];
    
    command = [NSString stringWithFormat:@"%@%@", command, distanceAndTime];
    
    
    
    [serialInputField setStringValue:command];
    if([chkAutoSend state] == 1){
        [self writeString:[serialInputField stringValue]];
        //[serialInputField setStringValue:@""];
    }
    

    
}

static bool standing = false;

-(void) cycleTest{
    
    if(cycleTesting){
        if([devcSpring TimeTillAtGoal] == 0){
            if(standing){
                [self performSelectorOnMainThread:@selector(runPoseByName:) withObject:@"squat" waitUntilDone:YES];
            }else{
                [self performSelectorOnMainThread:@selector(runPoseByName:) withObject:@"stand" waitUntilDone:YES];
            }
            
            standing = !standing;
           
 //           
        }else{
            
  //          [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cycleTest) userInfo:nil repeats:NO] ;
           // [self performSelector:@selector(cycleTest) withObject:nil afterDelay:1];
        }
    
    }
    //[self performSelector:@selector(cycleTest) withObject:self afterDelay:3];
    //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cycleTest) userInfo:nil repeats:NO] ;
}

static bool cycleTesting = false;
- (IBAction)btnCycleTest:(id)sender {
    cycleTesting = !cycleTesting;
    if(cycleTesting){
        //[self performSelectorInBackground:@selector(cycleTest) withObject:nil];
         [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(cycleTest) userInfo:nil repeats:YES] ;
    }else{
        [NSTimer cancelPreviousPerformRequestsWithTarget: self];
    }

    
}

- (IBAction)btnCycleTestEmbedded:(id)sender {
    cycleTesting = !cycleTesting;
    if(cycleTesting){
        //[self performSelectorInBackground:@selector(cycleTest) withObject:nil];
        [self writeString:@"@Left.Ankle.MuscleX.SetNewGoal,85,4000&Left.Ankle.MuscleZ.SetNewGoal,82,4000&Left.Hip.MuscleX.SetNewGoal,109,4000&Left.Hip.MuscleY.SetNewGoal,77,4000&Left.Hip.MuscleZ.SetNewGoal,84,4000&Left.Knee.MuscleX.SetNewGoal,70,4000&Right.Ankle.MuscleX.SetNewGoal,85,4000&Right.Ankle.MuscleZ.SetNewGoal,82,4000&Right.Hip.MuscleX.SetNewGoal,109,4000&Right.Hip.MuscleY.SetNewGoal,77,4000&Right.Hip.MuscleZ.SetNewGoal,89,4000&Right.Knee.MuscleX.SetNewGoal,70,4000>Left.Ankle.MuscleX.SetNewGoal,110,4000&Left.Ankle.MuscleZ.SetNewGoal,84,4000&Left.Hip.MuscleX.SetNewGoal,80,4000&Left.Hip.MuscleY.SetNewGoal,63,4000&Left.Hip.MuscleZ.SetNewGoal,65,4000&Left.Knee.MuscleX.SetNewGoal,131,4000&Right.Ankle.MuscleX.SetNewGoal,110,4000&Right.Ankle.MuscleZ.SetNewGoal,79,4000&Right.Hip.MuscleX.SetNewGoal,80,4000&Right.Hip.MuscleY.SetNewGoal,63,4000&Right.Hip.MuscleZ.SetNewGoal,80,4000&Right.Knee.MuscleX.SetNewGoal,131,4000;"];
        
    }else{
        [self writeString:@"!stop"];
    }

}


// action from the reset button
- (IBAction) resetButton: (NSButton *) btn {
    @try{
	// set and clear DTR to reset an arduino
        [cSpringSerial resetSerial];
	        
    }@catch (NSException* e) {
        
    }
}

- (IBAction)btnSaveCommand:(id)sender {
    
    //savedActions Save From Stand
    //left.Extend,15,1000&right.Extend,15,1000&left.LeanForward,10,1000
    
    //left.Extend,15,1000&right.Extend,15,1000&left.LeanBackward,10,1000
    
    NSButton* newButton = [[NSButton alloc] initWithFrame:NSRectFromCGRect(CGRectMake(10, ((scvSavedActions.subviews.count - 3) * 24) + 10, scvSavedActions.frame.size.width - 20 , 24))];
    [newButton setTitle:@"left.Extend,15,1000&right.Extend,15,1000&left.LeanBackward,10,1000"];
    [newButton setAutoresizingMask:NSViewWidthSizable];
    [newButton setEnabled:YES];
    [newButton setBezelStyle:NSRoundedBezelStyle];
    [newButton setTarget:self];
    [newButton setAction:@selector(hitAnActionButton:)];
    
   // NSView* buttonView = [[NSView alloc] init];

    [scvSavedActions addSubview:newButton];
   // [scvSavedActions setAutoresizesSubviews:YES];
    

}


-(void) displaycSpringStatus{
    [txtActionSequencesRemaining setStringValue:[NSString stringWithFormat:@"%u", devcSpring.NumberOfActionsSequencesRemaining]];
    [txtTimeTillFinished setStringValue:[NSString stringWithFormat:@"%u", devcSpring.TimeTillAtGoal]];
    [txtNumberOfMovingMuscles setStringValue:[NSString stringWithFormat:@"%u", devcSpring.NumberOfMusclesStillMoving]];
    [txtFinishedMoving setStringValue:[NSString stringWithFormat:@"%d", devcSpring.FinishedMoving]];
    [txtPowerStatus setStringValue:[NSString stringWithFormat:@"%d", devcSpring.PowerOn]];
    [txtBatteryCurrent setStringValue:[NSString stringWithFormat:@"%d", devcSpring.BatteryCurrent]];
    [txtBatteryVoltage setStringValue:[NSString stringWithFormat:@"%d", devcSpring.BatteryVoltage]];

}

// The imageView should always be the same size as the enclosing scrollview regardless of
// the bounds of the clipView. We need to do this manually because auto-layout would try
// to size the view to the bounds of the clipview effectively nulling the magnification.
//
- (void)setFrameSize:(NSSize)newSize {
    NSScrollView *scrollView = [self scvSavedActions];
    
    for (int index = 0; index < scrollView.subviews.count; index ++){
        [[scrollView.subviews objectAtIndex:index] setWidth:scvSavedActions.frame.size.width - 20];
    }
}

- (void) writecSpringPose{
    //if([[serialInputField stringValue] isEqualToString:@""]){
        if(devcSpring.FinishedMoving == NO){
            [vsLeftAnkleX setDoubleValue:devcSpring.LeftAnkleMuscleX];
            [vsLeftAnkleZ setDoubleValue:devcSpring.LeftAnkleMuscleZ];
            [vsLeftHipX setDoubleValue:devcSpring.LeftHipMuscleX];
            [vsLeftHipY setDoubleValue:devcSpring.LeftHipMuscleY];
            [vsLeftHipZ setDoubleValue:devcSpring.LeftHipMuscleZ];
            [vsLeftKneeX setDoubleValue:devcSpring.LeftKneeMuscleX];
            
            [vsRightAnkleX setDoubleValue:devcSpring.RightAnkleMuscleX];
            [vsRightAnkleZ setDoubleValue:devcSpring.RightAnkleMuscleZ];
            [vsRightKneeX setDoubleValue:devcSpring.RightKneeMuscleX];
            [vsRightHipX setDoubleValue:devcSpring.RightHipMuscleX];
            [vsRightHipY setDoubleValue:devcSpring.RightHipMuscleY];
            [vsRightHipZ setDoubleValue:devcSpring.RightHipMuscleZ];
        }
   // }
    
}

- (void) writecSpringSensorPose{
 
    [bvLeftFoot setBubbleXLocation:devcSpring.LeftFootOrientationZ];
    [bvLeftFoot setBubbleYLocation:devcSpring.LeftFootOrientationX];
    [bvLeftShin setBubbleXLocation:devcSpring.LeftShinOrientationZ];
    [bvLeftShin setBubbleYLocation:devcSpring.LeftShinOrientationX];
    [bvLeftThigh setBubbleXLocation:devcSpring.LeftThighOrientationZ];
    [bvLeftThigh setBubbleYLocation:devcSpring.LeftThighOrientationX];
    
    [bvTorso setBubbleXLocation:devcSpring.TorsoOrientationZ];
    [bvTorso setBubbleYLocation:devcSpring.TorsoOrientationX];
    
    
    [bvRightFoot setBubbleXLocation:devcSpring.RightFootOrientationZ];
    [bvRightFoot setBubbleYLocation:devcSpring.RightFootOrientationX];
    [bvRightShin setBubbleXLocation:devcSpring.RightShinOrientationZ];
    [bvRightShin setBubbleYLocation:devcSpring.RightShinOrientationX];
    [bvRightThigh setBubbleXLocation:devcSpring.RightThighOrientationZ];
    [bvRightThigh setBubbleYLocation:devcSpring.RightThighOrientationX];
    
    [bvLeftThigh display];
    [bvLeftShin display];
    [bvLeftFoot display];
    [bvRightFoot display];
    [bvRightShin display];
    [bvRightThigh display];
    [bvTorso display];
}



// send a string to the serial port
- (void) writeString: (NSString *) str {
    
	if([cSpringSerial writeString:str]) {
        
        str = [NSString stringWithFormat:@"%@ %@", str, @"\n\n"];
        NSAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: str];
        //[inputBuffer appendString:[NSString stringWithString:[attrString string]]];
        
        NSTextStorage *textStorage = [serialInputLog textStorage];
        [textStorage beginEditing];
        [textStorage appendAttributedString:attrString];
        [textStorage endEditing];
        [attrString release];
        
        // scroll to the bottom
        NSRange myRange;
        myRange.length = 1;
        myRange.location = [textStorage length];
        [serialInputLog scrollRangeToVisible:myRange];
        
        
	} else {
		// make sure the user knows they should select a serial port
		[self appendToIncomingText:@"\n ERROR:  Select a Serial Port from the pull-down menu\n"];
	}
}

// send a byte to the serial port
- (void) writeByte: (uint8_t *) val {
   	if(![cSpringSerial writeByte:val]) {
		// make sure the user knows they should select a serial port
		[self appendToIncomingText:@"\n ERROR:  Select a Serial Port from the pull-down menu\n"];
	}
}


- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor
doCommandBySelector:(SEL)commandSelector {
    if( commandSelector == @selector(moveUp:) ){
        // Your increment code
        return YES;    // We handled this command; don't pass it on
    }
    if( commandSelector == @selector(moveDown:) ){
        // Your decrement code
        return YES;
    }
    if( commandSelector == @selector(insertNewline:) ){
        // Your decrement code
        [self sendText:control];
    }

    
    return NO;    // Default handling of the command
    
}
//
//- (void) displayCSpringPoses{
//    NSArray* poseNames = [cSpringPoses listAllPoses];
//    
//    NSButton* btnEachPoseButton = [[NSButton alloc]init];
//    [btnEachPoseButton setTitle:@"Squat"];
//    
//
//    
//}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // Get a new ViewCell
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    NSArray* poseNames = [cSpringPoses listAllPoses] ;
    // Since this is a single-column table view, this would not be necessary.
    // But it's a good practice to do it in order by remember it when a table is multicolumn.

    if( [tableColumn.identifier isEqualToString:@"PoseColumn"] )
    {
        NSString *poseName = [poseNames objectAtIndex:row];
        [[tblSavedPoses rowViewAtRow:row makeIfNecessary:NO] setToolTip:poseName];
        //    cellView.imageView.image = bugDoc.thumbImage;
        cellView.textField.stringValue = poseName;
        [cellView setToolTip:poseName];
        return cellView;
    }
    if( [tableColumn.identifier isEqualToString:@"DeletePoseColumn"] )
    {
        //NSView* deleteView = [[NSView alloc]init];
        NSButton* deleteCell = [[cellView subviews]objectAtIndex:0];
        
        
        NSString *poseName = [poseNames objectAtIndex:row];
        [deleteCell setTitle:@"delete"];
        [deleteCell setAction:@selector(removePoseForPoseName:)];
        [deleteCell setToolTip:poseName];
        [deleteCell setTarget:self];
        return cellView;
    }
    return cellView;
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification{
    NSString* poseToRun = [[tblSavedPoses rowViewAtRow:[tblSavedPoses selectedRow] makeIfNecessary:NO] toolTip];
    [self runPoseByName:poseToRun];
    [tblSavedPoses deselectAll:nil];
    [txtPoseName setStringValue:poseToRun];
}
- (IBAction) removePoseForPoseName:(id) sender{
    NSButton* deleteButton = (NSButton*)sender;
    NSString* poseNameToDelete = [deleteButton toolTip];
    
    [chkAutoSend setState:0];
    [self runPoseByName:poseNameToDelete];
    [txtPoseName setStringValue:poseNameToDelete];
    
    
    [cSpringPoses removePoseByName:poseNameToDelete];
    [tblSavedPoses reloadData];
    

}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[cSpringPoses listAllPoses] count];
}



- (void) alertDidEnd:(NSAlert *) alert returnCode:(int) returnCode contextInfo:(int *) contextInfo
{
    *contextInfo = returnCode;
}



- (IBAction)btnMusicTest:(id)sender {
    [self performSelectorInBackground:@selector(danceInBackground) withObject:nil];
}

bool isMusicPlaying;
-(void) doMusic{
    isMusicPlaying = true;
    NSString* songPath = @"Baby";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:songPath ofType:@"m4a"];
    NSData* songData = [[NSData alloc] initWithContentsOfFile:filePath];
    
	NSError *error;
    
    AVAudioPlayer* babySongPlayer = [[AVAudioPlayer alloc] initWithData:songData error:&error];
    babySongPlayer.numberOfLoops = -1;
    
    if (babySongPlayer == nil){
		NSLog([error description]);
    }else{
		[babySongPlayer play];
    }
}


-(void) waitTillNextQuarterBeat{
    usleep(920000);
}

-(void) waitTillNextHalfBeat{
    usleep(1840000);
}

-(void) waitTillNextBeat{
    usleep(3680000);
}

-(void) waitForFirstBeat{
    usleep(4780000);
}

-(void) danceInBackground{
    
    [self doMusic];
    
    //[self writeString:@">right.toedown,2,500;"];
    //[self writeString:@">left.toedown,2,500;"];
    [self waitTillNextHalfBeat];
    //[self waitForFirstBeat];
    //for(int index = 0; index < 5; index ++){
    while (isMusicPlaying) {
        [self danceFromStart];
        //[self danceFromFirstClass];
    }
}


-(void) danceFromStart{
    //[self writeString:@">shiftleft;"];
    
    [self writeString:@">shiftleft,10,500;"];
    [self waitTillNextHalfBeat];
    
    [self writeString:@">right.bend,10,500&right.toedown,10,500"];
    [self waitTillNextHalfBeat];
    
    [self writeString:@">right.twistin,40,500"];
    [self waitTillNextQuarterBeat];
    
    [self writeString:@">right.twistout,40,500"];
    [self waitTillNextQuarterBeat];
    

    
    [self writeString:@">right.extend,10,500&right.toeup,10,500"];
    [self waitTillNextHalfBeat];
    
    [self writeString:@">shiftright,10,500;"];
    [self waitTillNextHalfBeat];
    
    [self writeString:@">shiftright,10,500;"];
    [self waitTillNextHalfBeat];
    
    [self writeString:@">shiftleft,10,500;"];
    [self waitTillNextHalfBeat];
    
    
    
    [self writeString:@">right.bend,10,500;"];
    [self waitTillNextHalfBeat];
    [self writeString:@">right.extend,10,500;"];
    [self waitTillNextHalfBeat];
    [self writeString:@">left.bend,10,500;"];
    [self waitTillNextHalfBeat];
    [self writeString:@">left.extend,10,500;"];
    [self waitTillNextHalfBeat];
    

    
    
    
        
}


-(void) danceFromFirstClass{
    //[self writeString:@">shiftleft;"];
//    
//    [self writeString:@">left.moveforward,10,500;"];
//    [self waitTillNextQuarterBeat];
//    
//    [self writeString:@">right.movebackward,10,500;"];
//    [self waitTillNextQuarterBeat];
//    
//    [self writeString:@">right.moveforward,10,500;"];
//    [self waitTillNextQuarterBeat];
//    
//    [self writeString:@">left.movebackward,10,500;"];
//    [self waitTillNextQuarterBeat];
    
    [self writeString:@">shiftleft,10,500;"];
    [self waitTillNextQuarterBeat];
    
    [self writeString:@">twistright,10,500;"];
    [self waitTillNextQuarterBeat];
    
    
    [self writeString:@">shiftright,10,500;"];
    [self waitTillNextQuarterBeat];
    
    [self writeString:@">shiftright,10,500;"];
    [self waitTillNextQuarterBeat];
    
    [self writeString:@">twistleft,10,500;"];
    [self waitTillNextQuarterBeat];
    
    [self writeString:@">shiftleft,10,500;"];
    [self waitTillNextQuarterBeat];
    
    [self writeString:@">shiftleft,10,500;"];
    [self waitTillNextQuarterBeat];
    
    [self writeString:@">left.bend,5,500;"];
    [self waitTillNextQuarterBeat];
    
    [self writeString:@">left.extend,5,500;"];
    [self waitTillNextQuarterBeat];
    
    [self writeString:@">shiftright,10,500;"];
    [self waitTillNextQuarterBeat];
    
    [self writeString:@">shiftright,10,500;"];
    [self waitTillNextQuarterBeat];
    
    [self writeString:@">right.bend,5,500;"];
    [self waitTillNextQuarterBeat];
    
    [self writeString:@">right.extend,5,500;"];
    [self waitTillNextQuarterBeat];
    
    [self writeString:@">shiftleft,10,500;"];
    [self waitTillNextQuarterBeat];
    

}

@end
