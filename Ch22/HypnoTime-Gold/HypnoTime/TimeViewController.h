//
//  TimeViewController.h
//  HypnoTime
//
//  Created by Brent Westmoreland on 6/15/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

@interface TimeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)showCurrentTime:(UIButton *)sender;

@end
