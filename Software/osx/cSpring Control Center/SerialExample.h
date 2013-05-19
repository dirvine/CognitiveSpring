//
//  SerialExample.h
//  Arduino Serial Example
//
//  Created by Gabe Ghearing on 6/30/09.
//

#import <Cocoa/Cocoa.h>

// import IOKit headers
#include "SerialNetworkingInterface.h"
#include "cSpringRobot.h"
#include "BubbleView.h"

#include <AVFoundation/AVFoundation.h>
#ifdef __cplusplus
#include "csOpenNIView.h"
#endif



#ifndef SerialExample_CLASS
#define SerialExample_CLASS

@class SerialNetworkingInterface;
@class cSpringRobot;
@class csOpenNIView;

@interface SerialExample :  NSObject<NSTableViewDelegate, NSTextFieldDelegate, NSTableViewDataSource> {
	IBOutlet NSPopUpButton *serialListPullDown;
    IBOutlet NSButton *chkAutoSend;
//    IBOutlet NSComboBox *serialListPullDown;
//    IBOutlet NSScrollView *serialOutputArea;
    IBOutlet NSTextView *serialOutputArea;
    IBOutlet NSTextView *serialOutputFiltered;
    IBOutlet NSTextView *serialInputLog;
    IBOutlet NSTextField *serialInputField;
	IBOutlet NSTextField *baudInputField;
    IBOutlet NSTextField *txtDistanceValue;
    IBOutlet NSBox *bxRight;
    IBOutlet NSBox *bxLeft;
    IBOutlet NSTextField *txtTimeValue;

//	bool readThreadRunning;
	NSTextStorage *storage;
    
   // IBOutlet UILabel* powerStatus;
    
    IBOutlet NSTextFieldCell *txtPowerStatus;
    IBOutlet NSTextFieldCell *txtBatteryVoltage;
    IBOutlet NSTextFieldCell *txtBatteryCurrent;
    IBOutlet NSTextFieldCell *txtFinishedMoving;
    IBOutlet NSTextFieldCell *txtTimeTillFinished;
    IBOutlet NSTextFieldCell *txtActionSequencesRemaining;
    IBOutlet NSTextFieldCell *txtNumberOfMovingMuscles;
    
    cSpringRobot* devcSpring;
    IBOutlet NSSlider *vsLeftHipY;
    IBOutlet NSSlider *vsLeftHipZ;
    IBOutlet NSSlider *vsLeftHipX;
    IBOutlet NSSlider *vsLeftKneeX;
    IBOutlet NSSlider *vsLeftAnkleZ;
    IBOutlet NSSlider *vsLeftAnkleX;
    
    IBOutlet NSSlider *vsRightHipZ;
    IBOutlet NSSlider *vsRightHipY;
    IBOutlet NSSlider *vsRightHipX;
    IBOutlet NSSlider *vsRightKneeX;
    IBOutlet NSSlider *vsRightAnkleZ;
    IBOutlet NSSlider *vsRightAnkleX;
    
    IBOutlet NSTextField *txtPoseName;
    
    
    IBOutlet BubbleView *bvRightFoot;
    IBOutlet BubbleView *bvRightShin;
    IBOutlet BubbleView *bvRightThigh;
    IBOutlet BubbleView *bvTorso;
    IBOutlet BubbleView *bvLeftThigh;
    IBOutlet BubbleView *bvLeftFoot;
    IBOutlet BubbleView *bvLeftShin;
    IBOutlet csOpenNIView *niDisplay;
    
    
    SerialNetworkingInterface *cSpringSerial;
    Poses* cSpringPoses;
    
} 


@property (retain) IBOutlet NSTableView *tblSavedPoses;
@property (retain) NSMutableString* inputBuffer;
- (IBAction) serialPortSelected: (id) cntrl;
- (IBAction) baudAction: (id) cntrl;
- (IBAction) refreshAction: (id) cntrl;
- (IBAction) sendText: (id) cntrl;
- (IBAction) sliderChange: (NSSlider *) sldr;
- (IBAction) hitAnActionButton: (NSButton *) btn;

- (IBAction)changedAPoseSlider:(id)sender;
- (IBAction) resetButton: (NSButton *) btn;
- (IBAction)btnSaveCommand:(id)sender;
- (IBAction)btnHitAPoseButton:(id)sender;
- (IBAction)btnSavePoseCommand:(id)sender;
- (IBAction)btnCopyRightToLeft:(id)sender;
- (IBAction)btnCopyLeftToRight:(id)sender;
- (IBAction)btnCycleTest:(id)sender;
- (IBAction)btnCycleTestEmbedded:(id)sender;
- (IBAction)btnMusicTest:(id)sender;




@property (retain) IBOutlet NSScrollView *scvSavedActions;

- (IBAction)clearSerial:(id)sender;
- (void) refreshSerialList: (NSString *) selectedText;

- (void) displaycSpringStatus;

- (void) writeString: (NSString *) str;
- (void) writeByte: (uint8_t *) val ;

- (void)appendToIncomingText: (NSString*) text;

- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector;

- (void) displayCSpringPoses;

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row ;
//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn*) tableColumn row:(NSInteger)row ;
- (void) tableViewSelectionDidChange:(NSNotification *)notification;
-(IBAction) removePoseForPoseName:(id) sender;
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView ;
-(void) runPoseByName:(NSString*) poseName;

@end


#endif