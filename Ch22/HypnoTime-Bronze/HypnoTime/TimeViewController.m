//
//  TimeViewController.m
//  HypnoTime
//
//  Created by Brent Westmoreland on 6/15/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "TimeViewController.h"

@implementation TimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setTitle: @"Time"];
        
        [[self tabBarItem] setImage: [UIImage imageNamed: @"Time"]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DLog(@"%@ Loaded", NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self showCurrentTime: nil];
}

- (IBAction)showCurrentTime:(UIButton *)sender
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    
    self.timeLabel.text = [dateFormatter stringFromDate: now];
    
}

@end
