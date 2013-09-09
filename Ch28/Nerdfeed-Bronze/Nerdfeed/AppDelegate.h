//
//  AppDelegate.h
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ListViewController *listViewController;
@property (strong, nonatomic) UINavigationController *navController;

@end
