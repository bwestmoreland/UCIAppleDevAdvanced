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
#import "Circle.h"

@interface TouchViewController()

@property (strong, nonatomic) UIPinchGestureRecognizer *pinch;

@end

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

- (NSMutableArray *)completeCircles
{
    if (!_completeCircles) {
        _completeCircles = [NSMutableArray array];
    }
    return _completeCircles;
}

- (NSMutableDictionary *)circlesInProcess
{
    if (!_circlesInProcess){
        _circlesInProcess = [NSMutableDictionary dictionary];
    }
    return _circlesInProcess;
}


- (UIPinchGestureRecognizer *)pinch
{
    if (!_pinch){
        _pinch = [[UIPinchGestureRecognizer alloc] initWithTarget: self
                                                           action: @selector(handlePinchGestureTouches:)];
    }
    return _pinch;
}

- (void)loadView
{
    TouchDrawView *view = [[TouchDrawView alloc] initWithFrame:CGRectZero];
    view.datasource = self;
    [self setView: view];
}

- (void)viewDidLoad
{
    [self.view addGestureRecognizer: self.pinch];
}

- (void)handlePinchGestureTouches: (UIPinchGestureRecognizer *)sender
{
    CGPoint firstTouch = [self.pinch locationOfTouch: 0 inView: self.view];
    CGPoint secondTouch = [self.pinch locationOfTouch: 1 inView: self.view];
    CGPoint center = [self.pinch locationInView: self.view];
    
    
    Circle *newCircle = [[Circle alloc] init];
    newCircle.begin = firstTouch;
    newCircle.end = secondTouch;
    newCircle.center = center;
    NSValue *key = [NSValue valueWithNonretainedObject: self.pinch];
    
    if ([sender state] == UIGestureRecognizerStateBegan ||
        [sender state] == UIGestureRecognizerStateChanged) {
        
        self.circlesInProcess[key] = newCircle;
    }
    else if ([sender state] == UIGestureRecognizerStateEnded ){
        [self.completeCircles addObject: self.circlesInProcess[key]];
        [self.circlesInProcess removeObjectForKey: key];
    }
    
    [self.view setNeedsDisplay];
}

- (void)beginStandardTouches:(NSSet *)touches
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
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self beginStandardTouches:touches];
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
    [self.circlesInProcess removeAllObjects];
    [self.completeCircles removeAllObjects];
    
    [self.view setNeedsDisplay];
}


@end
