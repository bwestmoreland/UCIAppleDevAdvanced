//
//  TouchViewController.h
//  TouchTracker
//
//  Created by Brent Westmoreland on 8/27/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//
#import "TouchDrawView.h"

@interface TouchViewController : UIViewController
<TouchDrawViewDataSource>

@property (strong, nonatomic) NSMutableArray *completeLines;
@property (strong, nonatomic) NSMutableDictionary *linesInProcess;
@property (strong, nonatomic) NSMutableArray *completeCircles;
@property (strong, nonatomic) NSMutableDictionary *circlesInProcess;

@end
