//
//  WhereamiViewController.h
//  WhereamiTests
//
//  Created by Brent Westmoreland on 6/5/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "Kiwi.h"
#import "AppDelegate.h"
#import "WhereamiViewController.h"


SPEC_BEGIN(AppDelegateSpec)

describe(@"AppDelegate", ^{
    
    context(@"after didFinishLaunchingWithOptions", ^{
        __block AppDelegate *appDelegate = nil;
        __block UIWindow *window = nil;
        __block WhereamiViewController *viewController = nil;
        
        beforeEach(^{ // Occurs before each enclosed "it"
            appDelegate = [[AppDelegate alloc] init];
            window = [[UIWindow alloc] init];
            appDelegate.window = window;
            viewController = [[WhereamiViewController alloc] initWithNibName:@"WhereamiView" bundle: nil];
            appDelegate.viewController = viewController;
            [appDelegate application: nil didFinishLaunchingWithOptions: nil];
            
        });
        
        afterEach(^{
            appDelegate = nil;
        });
        
        it(@"should have a window", ^{
            [[appDelegate window] shouldNotBeNil];
        });
        
        it(@"should have a key window", ^{
            [[theValue(window.keyWindow) should] beYes];
        });
        
        it(@"should have a root view controller that is our ViewController", ^{
            [[appDelegate.window.rootViewController should] beIdenticalTo:viewController];
        });
        
    });
});

SPEC_END