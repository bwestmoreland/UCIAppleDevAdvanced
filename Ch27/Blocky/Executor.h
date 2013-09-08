//
//  Executor.h
//  Blocky
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

@interface Executor : NSObject

@property (nonatomic, copy) int (^equation)(int, int);
- (int)computeWithValue: (int)value1 andValue: (int)value2;

@end
