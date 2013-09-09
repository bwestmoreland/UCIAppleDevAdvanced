//
//  FeedStore.m
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "FeedStore.h"
#import "RSSChannel.h"
#import "Connection.h"

@implementation FeedStore

+ (FeedStore *)sharedStore
{
    static FeedStore *_sharedStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [[FeedStore alloc] init];
    });
    
    return _sharedStore;
}

- (void)fetchRSSFeedWithCompletion:(void (^)(RSSChannel *, NSError *))block
{
    NSURL *url = [NSURL URLWithString: @"http://forums.bignerdranch.com/"
                  @"smartfeed.php?limit=1_DAY&sort_by=standard"
                  @"&feed_type=RSS2.0&feed_style=COMPACT"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    
    RSSChannel *channel = [[RSSChannel alloc] init];
    
    Connection *connection = [[Connection alloc] initWithRequest: request];
    
    [connection setCompletionBlock: block];
    
    [connection setXmlRootObject: channel];
    
    [connection start];
}

- (void)fetchTopSongs:(int)count withCompletion:(void (^)(RSSChannel *, NSError *))block
{
    NSString *requestString = [NSString stringWithFormat:
                               @"http://itunes.apple.com/us/rss/topsongs/limit=%d/json", count];
    
    NSURL *url = [NSURL URLWithString: requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    RSSChannel *channel = [[RSSChannel alloc] init];
    
    Connection *connection = [[Connection alloc] initWithRequest: request];
    [connection setCompletionBlock: block];
    connection.jsonRootObject = channel;
    
    [connection start];
}

@end
