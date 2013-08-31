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

#pragma mark - Lazy Properties

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
                                                           action: @selector(drawCircleWithGesture:)];
    }
    return _pinch;
}

#pragma mark - UIViewController View Events

- (void)loadView
{
    TouchDrawView *view = [[TouchDrawView alloc] initWithFrame:CGRectZero];
    view.datasource = self;
    [self setView: view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer: self.pinch];
}

#pragma mark - UIPanGestureRecognizer

- (void)manageStateForCircle: (Circle *)circle usingPan: (UIPinchGestureRecognizer *)pinch
{
    NSValue *key = [NSValue valueWithNonretainedObject: pinch];
    //Pinch is in process
    if ([pinch state] == UIGestureRecognizerStateBegan ||
        [pinch state] == UIGestureRecognizerStateChanged) {
        
        self.circlesInProcess[key] = circle;
    }
    //Pinch is done
    else if ([pinch state] == UIGestureRecognizerStateEnded ||
             [pinch state] == UIGestureRecognizerStateCancelled) {
        
        [self.completeCircles addObject: self.circlesInProcess[key]];
        [self.circlesInProcess removeObjectForKey: key];
    }
}

- (void)drawCircleWithGesture: (UIPinchGestureRecognizer *)sender
{
    CGPoint firstTouch = [sender locationOfTouch: 0 inView: self.view];
    CGPoint secondTouch = [sender locationOfTouch: 1 inView: self.view];
    CGPoint center = [sender locationInView: self.view];
    
    Circle *newCircle = [[Circle alloc] initWithBeginning: firstTouch
                                                      end: secondTouch
                                                   center: center];
    
    [self manageStateForCircle: newCircle usingPan: sender];
    
    [self.view setNeedsDisplay];
}

#pragma mark - UIResponder

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
