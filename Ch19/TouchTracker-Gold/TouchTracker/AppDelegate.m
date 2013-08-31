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

#pragma mark - NSCoder Archiving

//TODO: This should probably be moved out of the app delegate

- (NSString *)documentDirectory
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return documentDirectory;
}

- (NSString *)lineArchivePath
{
    NSString *documentDirectory = [self documentDirectory];
    
    return [documentDirectory stringByAppendingPathComponent:@"lines.archive"];
}


- (NSString *)circleArchivePath
{
    NSString *documentDirectory = [self documentDirectory];
    
    return [documentDirectory stringByAppendingPathComponent:@"circle.archive"];
}

- (BOOL)saveCirclesAndLines
{
    BOOL lineSuccess = [NSKeyedArchiver archiveRootObject: self.touchViewController.completeLines
                                               toFile: [self lineArchivePath]];
    
    BOOL circleSuccess = [NSKeyedArchiver archiveRootObject: self.touchViewController.completeCircles
                                               toFile: [self circleArchivePath]];
    return lineSuccess && circleSuccess;
}

#pragma mark - UIApplicationDelegate

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
    BOOL success = [self saveCirclesAndLines];
    
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

#pragma mark - Lazy Properties

- (TouchViewController *)touchViewController
{
    if (!_touchViewController){
        _touchViewController = [[TouchViewController alloc] initWithNibName: nil
                                                                     bundle: nil];
    }
    return _touchViewController;
}

@end
