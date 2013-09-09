//
//  FeedStore.h
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

@class RSSChannel;

@interface FeedStore : NSObject


+ (FeedStore *)sharedStore;

- (void)fetchRSSFeedWithCompletion: (void (^)(RSSChannel *channel, NSError *error))block;

- (void)fetchTopSongs: (int)count
       withCompletion: (void(^)(RSSChannel *obj, NSError *error))block;


@end
