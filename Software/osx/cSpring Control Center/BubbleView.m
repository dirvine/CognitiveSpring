//
//  BubbleView.m
//  cSpring Control Center
//
//  Created by Sean on 1/28/13.
//
//

#import "BubbleView.h"



@implementation BubbleView
@synthesize BubbleXLocation,BubbleYLocation;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}




- (void) drawWater{
    NSRect bounds = [self bounds];
    
    NSBezierPath *path;
    
    CGFloat emptySpace = 10;  // Defines the amount of padding between the path and the enclosing view


    
    
    CGFloat width = NSMaxY(bounds) - emptySpace;
    path = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(emptySpace/2,emptySpace/2,width, width)];
    
    
    NSGradient *borderGradient =
    [[[NSGradient alloc]
      initWithStartingColor:[NSColor colorWithCalibratedRed:0.50 green:1.0 blue:.250 alpha:.5]
      endingColor:[NSColor colorWithCalibratedRed:.25 green:1.0 blue:0.0 alpha:1]]
     autorelease];
	[borderGradient drawInBezierPath:path angle:-90];

    [path setClip];
    
    
}

- (void) drawBubbleAtX:(float) x andY:(float) y{
    NSBezierPath *path ;
    NSRect bounds = [self bounds];
    
    CGFloat emptySpace = 20;  // Defines the amount of padding between the path and the enclosing view

    
    [lineColor set];
    
    CGFloat width = NSMaxY(bounds) - emptySpace;
    

    path = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(((width/2) + x/2.5),((width/2) + y/2.5),width/4, width/4)];
    
    NSGradient *borderGradient =
    [[[NSGradient alloc]
      initWithStartingColor:[NSColor colorWithCalibratedRed:0.50 green:1.0 blue:.75 alpha:.5]
      endingColor:[NSColor colorWithCalibratedRed:0.750 green:1.0 blue:1.0 alpha:1]]
     autorelease];
	[borderGradient drawInBezierPath:path angle:-90];

    
    [path setClip];
    
}

-(void) draw{
    [self drawRect:self.bounds];

}

- (void)drawRect:(NSRect)rect{
    NSGraphicsContext *currentContext = [NSGraphicsContext currentContext];
    
    [NSGraphicsContext saveGraphicsState];
    
    [self drawWater];
    // [currentContext restoreGraphicsState];
    // [NSGraphicsContext saveGraphicsState];
    
    [self drawBubbleAtX:BubbleXLocation andY:BubbleYLocation];
    
    [currentContext restoreGraphicsState];
    
}

@end
