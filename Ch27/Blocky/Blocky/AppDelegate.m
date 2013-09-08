//
//  AppDelegate.m
//  Blocky
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "AppDelegate.h"
#import "Executor.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    int multiplier = 3;
    
    Executor *executor = [[Executor alloc] init];
    [executor setEquation: ^int(int x, int y) {
        int sum = x + y;
        return multiplier * sum;
    }];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"%d", [executor computeWithValue: 2 andValue: 5]);
    }];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
