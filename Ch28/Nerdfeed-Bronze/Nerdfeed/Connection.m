//
//  Connection.m
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "Connection.h"

static NSMutableArray *sharedConnectionList = nil;

@interface Connection()
{
    NSURLConnection *_connection;
    NSMutableData *_container;
}

@end

@implementation Connection

- (id)initWithRequest:(NSURLRequest *)request
{
    if (self = [super init]) {
        [self setRequest: request];
    }
    return self;
}

- (void)start
{
    _container = [[NSMutableData alloc] init];
    
    _connection = [[NSURLConnection alloc] initWithRequest: self.request
                                                  delegate: self
                                          startImmediately: YES];
    if (!sharedConnectionList)
        sharedConnectionList = [NSMutableArray array];
    
    [sharedConnectionList addObject: self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_container appendData: data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    id rootObject = nil;
    if ([self xmlRootObject]) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData: _container];
        [parser setDelegate: [self xmlRootObject]];
        [parser parse];
        
        rootObject = [self xmlRootObject];
    }
    else if ([self jsonRootObject]){
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: _container
                                                                   options: 0
                                                                     error: nil];
        [self.jsonRootObject readFromJSONDictionary: dictionary];
        rootObject = self.jsonRootObject;
    }
    
    if (self.completionBlock){
        self.completionBlock(rootObject, nil);
    }
    [sharedConnectionList removeObject: self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.completionBlock) {
        self.completionBlock(nil, error);
    }
    [sharedConnectionList removeObject: self];
}



@end
