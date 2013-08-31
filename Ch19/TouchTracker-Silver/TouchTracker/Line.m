//
//  Line.m
//  TouchTracker
//
//  Created by Brent Westmoreland on 8/27/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "Line.h"

@implementation Line

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _begin = [aDecoder decodeCGPointForKey:@"begin"];
        _end = [aDecoder decodeCGPointForKey:@"end"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeCGPoint: self.begin forKey: @"begin"];
    [aCoder encodeCGPoint: self.end forKey: @"end"];
}


@end
