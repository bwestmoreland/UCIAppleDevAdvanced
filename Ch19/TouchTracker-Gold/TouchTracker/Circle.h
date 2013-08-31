//
//  Circle.h
//  TouchTracker
//
//  Created by Brent Westmoreland on 8/31/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Circle : NSObject

@property (nonatomic) CGRect boundingBox;
@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;
@property (nonatomic) CGPoint center;

@end
