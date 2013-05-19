//
//  csOpenNIView.h
//  cSpring Control Center
//
//  Created by Sean on 2/2/13.
//
//

/****************************************************************************
 *                                                                           *
 *  OpenNI 1.x Alpha                                                         *
 *  Copyright (C) 2011 PrimeSense Ltd.                                       *
 *                                                                           *
 *  This file is part of OpenNI.                                             *
 *                                                                           *
 *  OpenNI is free software: you can redistribute it and/or modify           *
 *  it under the terms of the GNU Lesser General Public License as published *
 *  by the Free Software Foundation, either version 3 of the License, or     *
 *  (at your option) any later version.                                      *
 *                                                                           *
 *  OpenNI is distributed in the hope that it will be useful,                *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the             *
 *  GNU Lesser General Public License for more details.                      *
 *                                                                           *
 *  You should have received a copy of the GNU Lesser General Public License *
 *  along with OpenNI. If not, see <http://www.gnu.org/licenses/>.           *
 *                                                                           *
 ****************************************************************************/
// Application Usage:
// 1 - Switch to the depth map view mode.
// 2 - Switch to the psychedelic depth map view mode. In this mode each centimeter will have a difference color.
// 3 - Switch to the psychedelic depth map view mode. In this mode each centimeter will have a difference color and millimeters will have different shades.
// 4 - Switch to the depth map with rainbow colors view mode.
// 5 - Switch to the depth map with RGB registration view mode.
// 6 - Switch to the depth map with RGB registration view mode and a background image.
// 7 - Switch to the side by side of depth and image view mode.
// 8 - Switch to the image map with RGB registration view mode.
// 9 - Switch to the image map with RGB registration view mode. In this mode the depth will be semi transparent.
// 0 - Switch to the image map with RGB registration view mode. In this mode the depth will be semi transparent and use rainbow colors.
// - - Switch to the image map with RGB registration view mode. In this mode the depth will be semi transparent and use depth values color codes.
// = - Switch to the image map only view mode.
// p - Show the laser pointer and the cutoff parameters.
// m - Enable/Disable the mirror mode.
// q - Decrease the minimum depth cutoff by 1.
// Q - Decrease the minimum depth cutoff by 50.
// w - Increase the minimum depth cutoff by 1.
// W - Increase the minimum depth cutoff by 50.
// e - Decrease the maximum depth cutoff by 1.
// E - Decrease the maximum depth cutoff by 50.
// r - Increase the maximum depth cutoff by 1.
// R - Increase the maximum depth cutoff by 50.
// ESC - exit.

// --------------------------------
// Includes
// --------------------------------
#include <XnCppWrapper.h>

#if (XN_PLATFORM == XN_PLATFORM_LINUX_X86 || XN_PLATFORM == XN_PLATFORM_LINUX_ARM)
#define UNIX
#define GLX_GLXEXT_LEGACY
#endif

#if (XN_PLATFORM == XN_PLATFORM_MACOSX)
#define MACOS
#endif

#define GLH_EXT_SINGLE_FILE
#pragma warning(push, 3)
#include "glh_obs.h"
#include "glh_glut2.h"
#pragma warning(pop)

using namespace glh;

#include <XnLog.h>
#include "Device.h"
#include "Capture.h"
#include "Draw.h"
#include "Audio.h"
#include "Keyboard.h"
#include "Menu.h"
#include "Statistics.h"
#include "MouseInput.h"
#import <Cocoa/Cocoa.h>


#if (XN_PLATFORM == XN_PLATFORM_WIN32)
#include <conio.h>
#include <direct.h>
#elif (XN_PLATFORM == XN_PLATFORM_LINUX_X86 || XN_PLATFORM == XN_PLATFORM_LINUX_ARM || XN_PLATFORM == XN_PLATFORM_MACOSX)
#define _getch() getchar()
#endif

// --------------------------------
// Defines
// --------------------------------
#define SAMPLE_XML_PATH "/Users/seanreynoldscs/Dropbox/Repository/cSpring Control Center/SamplesConfig.xml"

// --------------------------------
// Types
// --------------------------------
enum {
	ERR_OK,
	ERR_USAGE,
	ERR_DEVICE,
	ERR_UNKNOWN
};




@interface csOpenNIView : NSOpenGLView

{

}

void KeyboardInput(char key, int um, int mn);

-(void) KeyboardInput:(char) key :(int) um :(int) mn;

-(void) glutLoop;

@end
