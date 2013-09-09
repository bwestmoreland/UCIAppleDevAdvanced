//
//  ListViewController.h
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//
@class WebViewController;

@interface ListViewController : UITableViewController

@property (nonatomic, strong) WebViewController *webViewController;

- (void)fetchEntries;

@end
