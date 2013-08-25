//
//  AppDelegate.m
//  Whereami
//
//  Created by Brent Westmoreland on 6/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "AppDelegate.h"
#import "WhereamiViewController.h"
#import "MapPoint.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSArray *allAnnotations = self.viewController.worldView.annotations;
    NSPredicate *isMapPoint = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@",
                           NSStringFromClass([MapPoint class])];
    
    BOOL success = [MapPoint savePointsArray: [allAnnotations filteredArrayUsingPredicate: isMapPoint]];
    
    if ( success ) {
        DLog(@"Application Backgrounding: did save annotations.");
    }
    else {
        DLog(@"Application failed to save annotations.");
    }

}

- (UIWindow *)window
{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _window;
}

- (WhereamiViewController *)viewController
{
    if (!_viewController){
        _viewController = [[WhereamiViewController alloc] initWithNibName: @"WhereamiView"
                                                                   bundle: nil];
    }
    return _viewController;
}


@end
