//
//  BubbleView.h
//  cSpring Control Center
//
//  Created by Sean on 1/28/13.
//
//
#import <Cocoa/Cocoa.h>

@interface BubbleView : NSView
{
//NSBezierPath *path;
    
    NSColor *lineColor, *fillColor, *backgroundColor;
}
//- (void)setPath:(NSBezierPath *)newPath ;

- (void) draw;



@property (nonatomic) float BubbleXLocation;
@property (nonatomic) float BubbleYLocation;

@end
