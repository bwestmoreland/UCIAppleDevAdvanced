//
//  Connection.h
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "JSONSerializable.h"

@interface Connection : NSObject
<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

- (id)initWithRequest: (NSURLRequest *)request;

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(id obj, NSError *error);
@property (nonatomic, strong) id <NSXMLParserDelegate> xmlRootObject;
@property (nonatomic, strong) id <JSONSerializable> jsonRootObject;

- (void)start;

@end
