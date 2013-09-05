//
//  Line.h
//  TouchTracker
//
//  Created by Brent Westmoreland on 9/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;
@property (nonatomic, strong) UIColor *color;

@end
