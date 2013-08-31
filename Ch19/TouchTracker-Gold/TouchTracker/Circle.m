//
//  Circle.m
//  TouchTracker
//
//  Created by Brent Westmoreland on 8/31/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "Circle.h"

@interface Circle()

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;
@property (nonatomic) CGPoint center;

@end

@implementation Circle

- (id)initWithBeginning:(CGPoint)begin end:(CGPoint)end center:(CGPoint)center
{
    if (self = [super init]) {
        [self setBegin: begin];
        [self setEnd: end];
        [self setCenter: center];
    }
    return self;
}

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

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeCGPoint: self.begin forKey: @"begin"];
    [aCoder encodeCGPoint: self.end forKey: @"end"];
    [aCoder encodeCGPoint: self.center forKey: @"center"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        [self setCenter: [aDecoder decodeCGPointForKey: @"center"]];
        [self setBegin: [aDecoder decodeCGPointForKey: @"begin"]];
        [self setEnd: [aDecoder decodeCGPointForKey: @"end"]];
    }
    return self;
}

@end
