//
//  TouchViewController.m
//  TouchTracker
//
//  Created by Brent Westmoreland on 9/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TouchViewController.h"
#import "TouchDrawView.h"
@implementation TouchViewController

- (void)loadView
{
    [self setView:[[TouchDrawView alloc] initWithFrame:CGRectZero]];
}


@end
