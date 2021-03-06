//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Brent Westmoreland on 8/27/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"

@interface TouchDrawView()

@end

@implementation TouchDrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor: [UIColor whiteColor]];
        [self setMultipleTouchEnabled: YES];
    }
    return self;
}

- (CGFloat)degreeOfAngleFromPoint: (CGPoint)firstPoint toPoint: (CGPoint)secondPoint
{
    CGFloat xDiff = secondPoint.x - firstPoint.x;
    CGFloat yDiff = secondPoint.y - firstPoint.y;
    
    return atan2f(yDiff, xDiff) * (180 / M_PI);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    [[UIColor blackColor] set];
    for (Line *line in [self.datasource completeLines]) {
        
        CGFloat angle = [self degreeOfAngleFromPoint: [line begin] toPoint: [line end]];
        
        UIColor *color = [UIColor colorWithHue: fabs(angle) / 180.0f
                                    saturation: 1.0f
                                    brightness: 1.0f
                                         alpha: 1.0f];
        
        [color set];
        
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    [[UIColor redColor] set];
    for (NSValue *v in [self.datasource linesInProcess]){
        
        Line *line = [[self.datasource linesInProcess] objectForKey: v];
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
}

@end
