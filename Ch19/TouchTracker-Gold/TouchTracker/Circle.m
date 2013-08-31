//
//  Circle.m
//  TouchTracker
//
//  Created by Brent Westmoreland on 8/31/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "Circle.h"

@implementation Circle

- (CGRect)boundingBox
{
    CGSize size = [self sizeFromBegin: self.begin andEnd: self.end];
    CGPoint origin = [self originFromSize: size andCenter: self.center];
    
    CGRect rect = CGRectMake(origin.x, origin.y, size.width, size.height);
    
    return rect;
}

- (CGSize)sizeFromBegin: (CGPoint)begin andEnd: (CGPoint)end
{
    return CGSizeMake(fabs(begin.x - end.x),
                      fabs(begin.y - end.y));
}

- (CGPoint)originFromSize: (CGSize)size andCenter: (CGPoint)center
{
    return CGPointMake(center.x - (size.width / 2),
                       center.y - (size.height / 2));
}

@end
