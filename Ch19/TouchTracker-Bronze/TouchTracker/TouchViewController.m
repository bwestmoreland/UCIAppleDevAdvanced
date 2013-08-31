//
//  TouchViewController.m
//  TouchTracker
//
//  Created by Brent Westmoreland on 8/27/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "TouchViewController.h"
#import "TouchDrawView.h"
#import "Line.h"

@implementation TouchViewController

- (NSMutableArray *)completeLines
{
    if (!_completeLines){
        _completeLines = [NSMutableArray array];
    }
    return _completeLines;
}

- (NSMutableDictionary *)linesInProcess
{
    if (!_linesInProcess){
        _linesInProcess = [NSMutableDictionary dictionary];
    }
    return _linesInProcess;
}

- (void)loadView
{
    TouchDrawView *view = [[TouchDrawView alloc] initWithFrame:CGRectZero];
    view.datasource = self;
    [self setView: view];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches){
        if ([t tapCount] > 1) {
            [self clearAll];
            return;
        }
        NSValue *key = [NSValue valueWithNonretainedObject: t];
        
        CGPoint loc = [t locationInView: self.view];
        Line *newLine = [[Line alloc] init];
        [newLine setBegin: loc];
        [newLine setEnd: loc];
        [self.linesInProcess setObject: newLine forKey: key];
    }
    [self.view setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches){
        NSValue *key = [NSValue valueWithNonretainedObject: t];
        
        Line *line = [self.linesInProcess objectForKey: key];
        
        CGPoint loc = [t locationInView: self.view];
        [line setEnd: loc];
    }
    [self.view setNeedsDisplay];
}

- (void)endTouches: (NSSet *)touches
{
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject: t];
        Line *line = [self.linesInProcess objectForKey: key];
        
        if (line){
            [self.completeLines addObject: line];
            [self.linesInProcess removeObjectForKey: key];
        }
    }
    [self.view setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches: touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches: touches];
}

- (void)clearAll
{
    [self.linesInProcess removeAllObjects];
    [self.completeLines removeAllObjects];
    
    [self.view setNeedsDisplay];
}


@end
