//
//  JSONSerializable.h
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONSerializable <NSObject>

- (void)readFromJSONDictionary: (NSDictionary *)dictionary;

@end
