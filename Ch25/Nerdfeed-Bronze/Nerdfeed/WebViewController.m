//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController


- (void)loadView
{
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *webView = [[UIWebView alloc] initWithFrame: screenFrame];
    webView.scalesPageToFit = YES;
    
    self.view = webView;
}


- (UIWebView *)webView
{
    return (UIWebView *)self.view;
}


@end
