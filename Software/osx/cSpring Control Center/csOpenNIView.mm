//
//  csOpenNIView.m
//  cSpring Control Center
//
//  Created by Sean on 2/2/13.
//
//

#import "csOpenNIView.h"


// --------------------------------
// Global Variables
// --------------------------------
/* When true, frames will not be read from the device. */
bool g_bPause = false;
/* When true, only a single frame will be read, and then reading will be paused. */
bool g_bStep = false;


glut_perspective_reshaper reshaper;
glut_callbacks cb;

IntPair mouseLocation;
IntPair windowSize;

@implementation csOpenNIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self viewInit];
    //[self performSelectorInBackground:@selector(glutLoop) withObject:NULL];
    return self;
}

-(void) glutLoop{
  //  glutMainLoop();
}

// --------------------------------
// Utilities
// --------------------------------
void MotionCallback(int x, int y)
{
	mouseInputMotion(int((double)x/windowSize.X*WIN_SIZE_X), int((double)y/windowSize.Y*WIN_SIZE_Y));
}

void MouseCallback(int button, int state, int x, int y)
{
	mouseInputButton(button, state, int((double)x/windowSize.X*WIN_SIZE_X), int((double)y/windowSize.Y*WIN_SIZE_Y));
}

void KeyboardCallback(unsigned char key, int /*x*/, int /*y*/)
{
	if (isCapturing())
	{
		captureStop(0);
	}
	else
	{
		handleKey(key);
	}
    
	glutPostRedisplay();
}

void ReshapeCallback(int width, int height)
{
	windowSize.X = width;
	windowSize.Y = height;
	windowReshaped(width, height);
}

void IdleCallback()
{
	XnStatus nRetVal = XN_STATUS_OK;
	if (g_bPause != TRUE)
	{
		// read a frame
		readFrame();
        
		// play the audio
		audioPlay();
        
		// capture if needed
		nRetVal = captureFrame();
		if (nRetVal != XN_STATUS_OK)
		{
			displayMessage("Error capturing frame: '%s'", xnGetStatusString(nRetVal));
		}
        
		// add to statistics
		statisticsAddFrame();
	}
    
	if (g_bStep == TRUE)
	{
		g_bStep = FALSE;
		g_bPause = TRUE;
	}
    
	glutPostRedisplay();
}


void init_opengl()
{
	glClearStencil(128);
	glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LESS);
	glEnable(GL_NORMALIZE);
    
	glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, GL_FALSE);
	GLfloat ambient[] = {0.5, 0.5, 0.5, 1};
	glLightfv(GL_LIGHT0, GL_AMBIENT, ambient);
	glLightf (GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.1f);
}


void closeSample(int errCode)
{
	captureStop(0);
	closeDevice();
    
//	if (errCode != ERR_OK)
//	{
//		printf("Press any key to continue . . .\n");
//		_getch();
//	}
//	exit(errCode);
}


void createKeyboardMap()
{
	startKeyboardMap();
	{
		startKeyboardGroup(KEYBOARD_GROUP_PRESETS);
		{
			registerKey('`', getPresetName(0), setPreset, 0);
			registerKey('1', getPresetName(1), setPreset, 1);
			registerKey('2', getPresetName(2), setPreset, 2);
			registerKey('3', getPresetName(3), setPreset, 3);
			registerKey('4', getPresetName(4), setPreset, 4);
			registerKey('5', getPresetName(5), setPreset, 5);
			registerKey('6', getPresetName(6), setPreset, 6);
			registerKey('7', getPresetName(7), setPreset, 7);
			registerKey('8', getPresetName(8), setPreset, 8);
			registerKey('9', getPresetName(9), setPreset, 9);
			registerKey('0', getPresetName(10), setPreset, 10);
			registerKey('-', getPresetName(11), setPreset, 11);
			registerKey('=', getPresetName(12), setPreset, 12);
		}
		endKeyboardGroup();
		startKeyboardGroup(KEYBOARD_GROUP_DEVICE);
		{
			registerKey('m', "Mirror on/off", toggleMirror, 0);
		}
		endKeyboardGroup();
		startKeyboardGroup(KEYBOARD_GROUP_DISPLAY);
		{
			registerKey('p', "Pointer Mode On/Off", togglePointerMode, 0);
			registerKey('f', "Full Screen On/Off", toggleFullScreen, 0);
			registerKey('?', "Show/Hide Help screen", toggleHelpScreen, 0);
		}
		endKeyboardGroup();
		startKeyboardGroup(KEYBOARD_GROUP_GENERAL);
		{
			registerKey('z', "Start/Stop Collecting Statistics", toggleStatistics, 0);
			registerKey('?', "Show/Hide help screen", toggleHelpScreen, 0);
			registerKey(27, "Exit", closeSample, ERR_OK);
		}
		endKeyboardGroup();
	}
	endKeyboardMap();
}

int changeDirectory(char* arg0)
{
	// get dir name
	XnChar strDirName[XN_FILE_MAX_PATH];
	XnStatus nRetVal = xnOSGetDirName(arg0, strDirName, XN_FILE_MAX_PATH);
	XN_IS_STATUS_OK(nRetVal);
    
	// now set current directory to it
	nRetVal = xnOSSetCurrentDir(strDirName);
	XN_IS_STATUS_OK(nRetVal);
    
	return 0;
}

- (void)viewInit{
    
    @try {
        
        // Xiron Init
        XnStatus rc = XN_STATUS_OK;
        EnumerationErrors errors;
        
        rc = openDeviceFromXml(SAMPLE_XML_PATH, errors);
        
        
        if (rc == XN_STATUS_NO_NODE_PRESENT)
        {
            XnChar strError[1024];
            errors.ToString(strError, 1024);
            printf("%s\n", strError);
            closeSample(ERR_DEVICE);
            //return (rc);
        }
        else if (rc != XN_STATUS_OK)
        {
            printf("Open failed: %s\n", xnGetStatusString(rc));
            //closeSample(ERR_DEVICE);
        }
        
        audioInit();
        captureInit();
        statisticsInit();
        
        createKeyboardMap();
        
        
        
    }
    @catch (NSException *exception) {
        
        
    }
}

void KeyboardInput(char key, int um, int mn){
    KeyboardCallback(key, um, mn);
}

-(void) KeyboardInput:(char) key :(int) um :(int) mn{
    KeyboardCallback(key, um, mn);
}


void drawAnObject ()

{
    
    @try {
    glColor3f(1.0f, 0.85f, 0.35f);
    
    glBegin(GL_TRIANGLES);
    
    {
        
        glVertex3f(  0.0,  0.6, 0.0);
        
        glVertex3f( -0.2, -0.3, 0.0);
        
        glVertex3f(  0.2, -0.3 ,0.0);
        
    }
    
    glEnd();
    }
    @catch (NSException *exception) {
        
        
    }
}

void drawAnotherObject ()

{
    
    glColor3f(.10f, 0.5f, 0.85f);
    
    glBegin(GL_TRIANGLES);
    
    {
        
        glVertex3f(  0.0,  0.6, 0.0);
        
        glVertex3f( -0.2, -0.3, 0.0);
        
        glVertex3f(  0.2, -0.3 ,0.0);
        
    }
    
    glEnd();
    
}

bool everyother = false;

-(void) drawRect: (NSRect) bounds
{
    @try{
        glClearColor(0, 0, 0, 0);
        
        glClear(GL_COLOR_BUFFER_BIT);
        
        init_opengl();
        drawInit();
        
        
        if(everyother){
            readFrame();
            drawFrame();
        }else{
           drawFrame();
        }

        
        everyother = !everyother;
        
        glFlush();
        [self setNeedsDisplay:true];
       // [self display];
    }
    @catch (NSException *exception) {
        
        
    }
}
@end
