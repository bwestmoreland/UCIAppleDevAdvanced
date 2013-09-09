//
//  AppDelegate.m
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (ListViewController *)listViewController
{
    if (!_listViewController) {
        _listViewController = [[ListViewController alloc] initWithStyle: UITableViewStylePlain];
    }
    return _listViewController;
}

- (UINavigationController *)navController
{
    if (!_navController) {
        _navController = [[UINavigationController alloc] initWithRootViewController: self.listViewController];
    }
    return _navController;
}

@end
