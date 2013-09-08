//
//  RSSChannel.h
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

@interface RSSChannel : NSObject
<NSXMLParserDelegate>

@property (nonatomic, weak) id parentParserDelegate;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *infoString;

@property (nonatomic, readonly, strong) NSMutableArray *items;

@end
