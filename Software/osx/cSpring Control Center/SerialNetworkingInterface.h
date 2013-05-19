//
//  SerialNetworkingInterface.h
//  cSpring Control Center
//
//  Created by Sean on 1/9/13.
//
//

#import <Foundation/Foundation.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/serial/IOSerialKeys.h>
#include <IOKit/IOBSD.h>
#include <IOKit/serial/ioss.h>
#include <sys/ioctl.h>
#include "SerialExample.h"

#ifndef SerialNetworkingInterfaceClass
#define SerialNetworkingInterfaceClass

@class SerialExample;


@interface SerialNetworkingInterface : NSObject{
    struct termios gOriginalTTYAttrs; // Hold the original termios attributes so we can reset them on quit ( best practice )
    bool readThreadRunning;
	
    SerialExample* display;
    
}


@property (retain) NSMutableString* inputBuffer;


- (id) initWithDisplay:(SerialExample*) newDisplay;

- (void)appendToIncomingText: (id) text;
- (void)incomingTextUpdateThread: (NSThread *) parentThread;

- (NSString *) openSerialPort: (NSString *)serialPortFile baud: (speed_t)baudRate ;


- (BOOL) writeString: (NSString *) str;
- (BOOL) writeByte: (uint8_t *) val;

- (void)setFrameSize:(NSSize)newSize ;
- (void) writecSpringPose;
- (void) closeSerial;
- (void) resetSerial;
- (void) SetBaud: (int) baud ;


@end

#endif