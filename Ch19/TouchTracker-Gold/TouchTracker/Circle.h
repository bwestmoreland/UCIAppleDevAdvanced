//
//  Circle.h
//  TouchTracker
//
//  Created by Brent Westmoreland on 8/31/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Circle : NSObject
<NSCoding>

@property (nonatomic) CGRect boundingBox;

- (id)initWithBeginning: (CGPoint)begin
                    end: (CGPoint)end
                 center: (CGPoint)center;

@end
