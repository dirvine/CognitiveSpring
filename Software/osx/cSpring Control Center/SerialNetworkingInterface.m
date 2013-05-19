//
//  SerialNetworkingInterface.m
//  cSpring Control Center
//
//  Created by Sean on 1/9/13.
//
//

#import "SerialNetworkingInterface.h"

@implementation SerialNetworkingInterface
@synthesize inputBuffer;

static int serialFileDescriptor = -1; // file handle to the serial port


-(id) initWithDisplay:(SerialExample*) newDisplay{
    [super init];
   // serialFileDescriptor = -1;
	readThreadRunning = FALSE;
    
    display = newDisplay;
    
	inputBuffer = [[NSMutableString alloc]init];
    
    return self;
    
}

// send a string to the serial port
- (BOOL) writeString: (NSString *) str {
    bool didThisWork = false;
	int bufferWriteSize = 33;
	NSRange range;
	range.length = bufferWriteSize;

	if(serialFileDescriptor!=-1) {
        if(([str characterAtIndex:0] == '>')||([str characterAtIndex:0] == '!')||([str characterAtIndex:0] == '&')||([str characterAtIndex:0] == '@')){
            str = [NSString stringWithFormat:@"%@%@", str, @";\n"];
        }else{
            str = [NSString stringWithFormat:@"%@%@%@",@">", str, @";\n"];
        }
		//Write the commands slower with less buffer;
		for(range.location = 0; range.location < [str length]; range.location += bufferWriteSize){			
			if((range.location + range.length) > [str length]){
				range.length = [str length] - range.location;
			}
			
			write(serialFileDescriptor, [[str substringWithRange:range] cStringUsingEncoding:NSUTF8StringEncoding], range.length);			
		}
        didThisWork = true;
	}

    return didThisWork;
}

// send a byte to the serial port
- (BOOL) writeByte: (uint8_t *) val {
    bool didThisWork = false;
	if(serialFileDescriptor!=-1) {
		write(serialFileDescriptor, val, 1);
        didThisWork = true;
	} else {
		// make sure the user knows they should select a serial port
		[self appendToIncomingText:@"\n ERROR:  Select a Serial Port from the pull-down menu\n"];
	}
    return didThisWork;
}


- (void) closeSerial{
    
    // close serial port if open
	if (serialFileDescriptor != -1) {
		close(serialFileDescriptor);
		serialFileDescriptor = -1;
	}
}


// action from baud rate change
- (void) SetBaud: (int) baud {
	if (serialFileDescriptor != -1) {
		speed_t baudRate = baud;
		
		// if the new baud rate isn't possible, refresh the serial list
		//   this will also deselect the current serial port
		if(ioctl(serialFileDescriptor, IOSSIOSPEED, &baudRate)==-1) {
			[self refreshSerialList:@"Error: Baud Rate out of bounds"];
			[self appendToIncomingText:@"Error: Baud Rate out of bounds"];
		}
	}
}




// open the serial port
//   - nil is returned on success
//   - an error message is returned otherwise
- (NSString *) openSerialPort: (NSString *)serialPortFile baud: (speed_t)baudRate {
	int success;
	
	NSString *errorMessage = nil;
	// close the port if it is already open
//	if (serialFileDescriptor != -1) {
//		close(serialFileDescriptor);
//		serialFileDescriptor = -1;
//		
//		// wait for the reading thread to die
//		while(readThreadRunning);
//		
//		// re-opening the same port REALLY fast will fail spectacularly... better to sleep a sec
//		sleep(0.5);
//	}
	if (serialFileDescriptor == -1) {
	// c-string path to serial-port file
	const char *bsdPath = [serialPortFile cStringUsingEncoding:NSUTF8StringEncoding];
	
	// Hold the original termios attributes we are setting
	struct termios options;
	
	// receive latency ( in microseconds )
	unsigned long mics = 3;
	
	// error message string
	
	// open the port
	//     O_NONBLOCK causes the port to open without any delay (we'll block with another call)
	serialFileDescriptor = open(bsdPath, O_RDWR | O_NOCTTY | O_NONBLOCK );
	
	if (serialFileDescriptor == -1) {
		// check if the port opened correctly
		errorMessage = @"Error: couldn't open serial port";
	} else {
		// TIOCEXCL causes blocking of non-root processes on this serial-port
		success = ioctl(serialFileDescriptor, TIOCEXCL);
		if ( success == -1) {
			errorMessage = @"Error: couldn't obtain lock on serial port";
		} else {
			success = fcntl(serialFileDescriptor, F_SETFL, 0);
			if ( success == -1) {
				// clear the O_NONBLOCK flag; all calls from here on out are blocking for non-root processes
				errorMessage = @"Error: couldn't obtain lock on serial port";
			} else {
				// Get the current options and save them so we can restore the default settings later.
				success = tcgetattr(serialFileDescriptor, &gOriginalTTYAttrs);
				if ( success == -1) {
					errorMessage = @"Error: couldn't get serial attributes";
				} else {
					// copy the old termios settings into the current
					//   you want to do this so that you get all the control characters assigned
					options = gOriginalTTYAttrs;
					
					/*
					 cfmakeraw(&options) is equivilent to:
					 options->c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON);
					 options->c_oflag &= ~OPOST;
					 options->c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
					 options->c_cflag &= ~(CSIZE | PARENB);
					 options->c_cflag |= CS8;
					 */
					cfmakeraw(&options);
					
					// set tty attributes (raw-mode in this case)
					success = tcsetattr(serialFileDescriptor, TCSANOW, &options);
					if ( success == -1) {
						errorMessage = @"Error: coudln't set serial attributes";
					} else {
						// Set baud rate (any arbitrary baud rate can be set this way)
						success = ioctl(serialFileDescriptor, IOSSIOSPEED, &baudRate);
						if ( success == -1) {
							errorMessage = @"Error: Baud Rate out of bounds";
						} else {
							// Set the receive latency (a.k.a. don't wait to buffer data)
							success = ioctl(serialFileDescriptor, IOSSDATALAT, &mics);
							if ( success == -1) {
								errorMessage = @"Error: coudln't set serial latency";
							}
						}
					}
				}
			}
		}
	}
	
	// make sure the port is closed if a problem happens
	if ((serialFileDescriptor != -1) && (errorMessage != nil)) {
		close(serialFileDescriptor);
		serialFileDescriptor = -1;
	}
    if(errorMessage == nil){
        readThreadRunning = TRUE;
        [self performSelectorInBackground:@selector(incomingTextUpdateThread:) withObject:[NSThread currentThread]];
        
    }
	}
	return errorMessage;
}


// updates the textarea for incoming text by appending text
- (void)appendToIncomingText: (id) text {
	// add the text to the textarea
    
	NSAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: text];
    [inputBuffer appendString:[NSString stringWithString:[attrString string]]];
    
	
	    
    NSRange range = [inputBuffer rangeOfString:@"\n"];
    if(range.length > 0){
        NSString *substring = [inputBuffer substringToIndex:(range.location + range.length)];
        //substring = [substring stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [display appendToIncomingText:substring];
        [inputBuffer setString:[inputBuffer substringFromIndex:(range.location + range.length)]];
     //   range = [inputBuffer rangeOfString:@"\n"];
    //}
    }
            

    
}

// This selector/function will be called as another thread...
//  this thread will read from the serial port and exits when the port is closed
- (void)incomingTextUpdateThread: (NSThread *) parentThread {
	
	// create a pool so we can use regular Cocoa stuff
	//   child threads can't re-use the parent's autorelease pool
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// mark that the thread is running
	readThreadRunning = TRUE;
	
	const int BUFFER_SIZE = 65536;
	char byte_buffer[BUFFER_SIZE]; // buffer for holding incoming data
	int numBytes=0; // number of bytes read during read
	NSString *text; // incoming text from the serial port
	
	// assign a high priority to this thread
	[NSThread setThreadPriority:1.0];
	
	// this will loop unitl the serial port closes
	while(readThreadRunning) {
		// read() blocks until some data is available or the port is closed
		numBytes = read(serialFileDescriptor, byte_buffer, BUFFER_SIZE); // read up to the size of the buffer
		if(numBytes>0) {
			// create an NSString from the incoming bytes (the bytes aren't null terminated)
			text = [NSString stringWithCString:byte_buffer length:numBytes];
			// this text can't be directly sent to the text area from this thread
			//  BUT, we can call a selctor on the main thread.
			[self performSelectorOnMainThread:@selector(appendToIncomingText:)
                                   withObject:text
                                waitUntilDone:YES];
		} else {
			break; // Stop the thread if there is an error
		}
	}
	
	// make sure the serial port is closed
	if (serialFileDescriptor != -1) {
		close(serialFileDescriptor);
		serialFileDescriptor = -1;
	}
	
	// mark that the thread has quit
	readThreadRunning = FALSE;
	
	// give back the pool
	[pool release];
}


-(void)resetSerial{
    struct timespec interval = {0,100000000}, remainder;
	if(serialFileDescriptor!=-1) {
		ioctl(serialFileDescriptor, TIOCSDTR);
		nanosleep(&interval, &remainder); // wait 0.1 seconds
		ioctl(serialFileDescriptor, TIOCCDTR);
	}
    
    [self closeSerial];
    

}

@end
