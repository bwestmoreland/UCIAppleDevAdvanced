//
//  AppDelegate.m
//  HypnoTime
//
//  Created by Brent Westmoreland on 6/15/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "AppDelegate.h"
#import "HypnosisViewController.h"
#import "TimeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    HypnosisViewController *hypnosisViewController = [[HypnosisViewController alloc] initWithNibName: nil bundle: nil];
    TimeViewController *timeViewController = [[TimeViewController alloc] initWithNibName: @"TimeView" bundle: nil];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    tabBarController.viewControllers = @[hypnosisViewController, timeViewController];
    
    self.window.rootViewController = tabBarController;
    
    UIColor *skyColor = [UIColor colorWithRed: 0.341 green: 0.804 blue: 0.98 alpha: 1];

    self.window.backgroundColor = skyColor;
    
    [self.window makeKeyAndVisible];
    return YES;
}


@end
