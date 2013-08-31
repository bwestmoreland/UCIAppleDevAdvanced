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

@property (copy, nonatomic) NSMutableArray *completeLines;
@property (copy, nonatomic) NSMutableDictionary *linesInProcess;

@end
