//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Brent Westmoreland on 9/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Line;
@interface TouchDrawView : UIView 
    <UIGestureRecognizerDelegate>

- (void)clearAll;
- (void)endTouches:(NSSet *)touches;

- (Line *)lineAtPoint:(CGPoint)p;
@property (nonatomic, weak) Line *selectedLine;

@end
