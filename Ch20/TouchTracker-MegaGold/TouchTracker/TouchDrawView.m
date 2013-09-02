//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Brent Westmoreland on 9/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"

@interface TouchDrawView()
{
    NSMutableDictionary *linesInProcess;
    NSMutableArray *completeLines;
    UIPanGestureRecognizer *pan;
    UITapGestureRecognizer *tap;
    UISwipeGestureRecognizer *swipe;
}

@end

@implementation TouchDrawView

- (id)initWithFrame:(CGRect)r
{
    self = [super initWithFrame:r];
    
    if (self) {
        linesInProcess = [NSMutableDictionary dictionary];
        
        completeLines = [NSMutableArray array];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self setMultipleTouchEnabled:YES];
        
        UITapGestureRecognizer *tapRecognizer = 
        [[UITapGestureRecognizer alloc] initWithTarget: self
                                                action: @selector(tap:)];
        
        [self addGestureRecognizer: tapRecognizer];

        UILongPressGestureRecognizer *press =
            [[UILongPressGestureRecognizer alloc] initWithTarget: self
                                                          action: @selector(longPress:)];
        [self addGestureRecognizer:press];
    
        pan = [[UIPanGestureRecognizer alloc] initWithTarget: self
                                                      action: @selector(moveLine:)];
        [pan setDelegate: self];
        [pan setCancelsTouchesInView: NO];
        [self addGestureRecognizer: pan];
        
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget: self
                                                          action: @selector(showColorSelector:)];
        swipe.numberOfTouchesRequired = 3;
        swipe.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer: swipe];
        
    }
    
    return self;
}

- (void)deleteLine:(id)sender
{
    [completeLines removeObject:[self selectedLine]];

    [self setNeedsDisplay];
}


- (void)moveLine:(UIPanGestureRecognizer *)gr
{
    if(![self selectedLine])
        return;
    
    CGPoint translation = [gr translationInView:self];
    if([gr state] == UIGestureRecognizerStateChanged) {
        CGPoint begin = [[self selectedLine] begin];
        CGPoint end = [[self selectedLine] end];
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        
        [[self selectedLine] setBegin:begin];
        [[self selectedLine] setEnd:end];
        [self setNeedsDisplay];
        
        [gr setTranslation:CGPointZero inView:self];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer == pan)
        return YES;
    return NO;
}

- (void)showColorSelector: (UISwipeGestureRecognizer *)swipe
{
    
}

- (void)longPress:(UIGestureRecognizer *)gr
{
    if([gr state] == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView: self];
        [self setSelectedLine: [self lineAtPoint: point]];
        if([self selectedLine]) {    
            [linesInProcess removeAllObjects];
        }
    } else if([gr state] == UIGestureRecognizerStateEnded) {
        [self setSelectedLine: nil];
    }
    [self setNeedsDisplay];
}

- (void)tap:(UIGestureRecognizer *)gr
{
    CGPoint point = [gr locationInView: self];
    [self setSelectedLine: [self lineAtPoint: point]];
    
    [linesInProcess removeAllObjects];
    
    if([self selectedLine]) {    
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle: @"Delete"
                                                            action: @selector(deleteLine:)];
        [menu setMenuItems: [NSArray arrayWithObject: deleteItem]];
        [menu setTargetRect: CGRectMake(point.x, point.y, 2, 2)
                     inView: self];
        [menu setMenuVisible: YES animated: YES];
    } else {
        [[UIMenuController sharedMenuController] setMenuVisible: NO
                                                       animated: YES];
    }
    
    [self setNeedsDisplay];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (Line *)lineAtPoint: (CGPoint)p
{    
    for(Line *l in completeLines) {
        CGPoint start = [l begin];
        CGPoint end = [l end];
        
        for(float t = 0.0; t <= 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            if(hypot(x - p.x, y - p.y) < 10.0) {
                return l;
            }
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    self.selectedLine = nil;
    [[UIMenuController sharedMenuController] setMenuVisible: NO
                                                   animated: YES];
    
    for (UITouch *t in touches) {
        
        if ([t tapCount] > 1) {
            [self clearAll];
            return;
        }

        NSValue *key = [NSValue valueWithNonretainedObject:t];

        CGPoint loc = [t locationInView:self];
        Line *newLine = [[Line alloc] init];
        [newLine setBegin:loc];
        [newLine setEnd:loc];

        [linesInProcess setObject:newLine forKey:key];
    }
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];

        Line *line = [linesInProcess objectForKey:key];

        CGPoint loc = [t locationInView:self];
        [line setEnd:loc];
    }
    [self setNeedsDisplay];
}

- (void)endTouches:(NSSet *)touches
{
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        Line *line = [linesInProcess objectForKey:key];
        if (line) {
            [completeLines addObject:line];
            [linesInProcess removeObjectForKey:key];
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}
- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

- (void)clearAll
{
    [linesInProcess removeAllObjects];
    [completeLines removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);

    [[UIColor blackColor] set];
    for (Line *line in completeLines) {
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }

    [[UIColor redColor] set];
    for (NSValue *v in linesInProcess) {
        Line *line = [linesInProcess objectForKey:v];
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    if([self selectedLine]) {
        [[UIColor greenColor] set];
        CGContextMoveToPoint(context, [[self selectedLine] begin].x, 
                             [[self selectedLine] begin].y);
        CGContextAddLineToPoint(context, [[self selectedLine] end].x, 
                                [[self selectedLine] end].y);
        CGContextStrokePath(context);
        
    }
}
@end
