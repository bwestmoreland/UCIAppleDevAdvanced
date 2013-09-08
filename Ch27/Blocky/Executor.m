//
//  Executor.m
//  Blocky
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "Executor.h"

@implementation Executor


- (int)computeWithValue:(int)value1 andValue:(int)value2
{
    if (!self.equation) {
        return 0;
    }
    
    return self.equation(value1, value2);
}

- (void)dealloc
{
    NSLog(@"Executor is being destroyed");
}

@end
