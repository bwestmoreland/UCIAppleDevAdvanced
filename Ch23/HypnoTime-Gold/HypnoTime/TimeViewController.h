//
//  TimeViewController.h
//  HypnoTime
//
//  Created by Brent Westmoreland on 6/15/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

@interface TimeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *whatTimeButton;

- (IBAction)showCurrentTime:(UIButton *)sender;

- (void)spinTimeLabel;

@end
