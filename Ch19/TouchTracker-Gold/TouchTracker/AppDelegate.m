//
//  AppDelegate.m
//  TouchTracker
//
//  Created by Brent Westmoreland on 8/27/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "AppDelegate.h"
#import "TouchViewController.h"

@implementation AppDelegate

- (NSString *)lineArchivePath
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"lines.archive"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.touchViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    BOOL success = [NSKeyedArchiver archiveRootObject: self.touchViewController.completeLines
                                               toFile: [self lineArchivePath]];
    
    if (!success) {
        NSLog(@"FAIL! %@", [self lineArchivePath]);
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.touchViewController.completeLines = [NSKeyedUnarchiver unarchiveObjectWithFile: [self lineArchivePath]];
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.touchViewController.completeLines = [NSKeyedUnarchiver unarchiveObjectWithFile: [self lineArchivePath]];
    
    return YES;
}




- (TouchViewController *)touchViewController
{
    if (!_touchViewController){
        _touchViewController = [[TouchViewController alloc] initWithNibName: nil
                                                                     bundle: nil];
    }
    return _touchViewController;
}

@end
