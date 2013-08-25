//
//  AppDelegate.m
//  Homepwner
//
//  Created by Brent Westmoreland on 6/15/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "AppDelegate.h"
#import "ItemStore.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.itemsViewController = [[ItemsViewController alloc] init];
    self.navController = [[UINavigationController alloc] initWithRootViewController: self.itemsViewController];
    self.window.rootViewController = self.navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    BOOL success = [[ItemStore sharedStore] saveChanges];
    
    if (success) {
        NSLog(@"Saved all the things!");
    }
    else {
        NSLog(@"Epic fail saving all the things.");
    }
}

@end
