//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Brent Westmoreland on 8/27/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"
#import "Circle.h"

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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    [[UIColor blackColor] set];
    for (Line *line in [self.datasource completeLines]) {
        
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    for (Circle *circle in [self.datasource completeCircles]) {
        CGContextStrokeEllipseInRect(context, circle.boundingBox);
    }
    
    [[UIColor redColor] set];
    for (NSValue *v in [self.datasource linesInProcess]){
        
        Line *line = [[self.datasource linesInProcess] objectForKey: v];
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    [[UIColor blueColor] set];
    for (NSValue *v in [self.datasource circlesInProcess]){
        Circle *circle = [[self.datasource circlesInProcess] objectForKey: v];
        CGContextAddEllipseInRect(context, circle.boundingBox);
        CGContextStrokePath(context);
    }
    
}

@end
