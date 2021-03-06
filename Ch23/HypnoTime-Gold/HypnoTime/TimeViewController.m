//
//  TimeViewController.m
//  HypnoTime
//
//  Created by Brent Westmoreland on 6/15/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "TimeViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    
    CGPoint originalPosition = self.whatTimeButton.layer.position;
    CGPoint offscreenPosition = CGPointMake(originalPosition.x - 300.0, originalPosition.y);
    
    CABasicAnimation *slide = [CABasicAnimation animationWithKeyPath: @"position"];
    [slide setDuration: 0.6];
    [slide setFromValue: [NSValue valueWithCGPoint: offscreenPosition]];
    [slide setToValue: [NSValue valueWithCGPoint: originalPosition]];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath: @"opacity"];
    [opacity setDuration: 1.2];
    [opacity setBeginTime: 0.6];
    [opacity setFromValue: @0.2];
    [opacity setToValue: @1];
    [opacity setRepeatCount: HUGE_VALF];
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    [animations setDuration: 20.0];
    [animations setAnimations: @[slide, opacity]];
    
    
    [self.whatTimeButton.layer addAnimation: animations forKey: nil];
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
    
    [self bounceTimeLabel];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"%@ finished %d", anim, flag);
}


- (void)spinTimeLabel
{
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath: @"transform.rotation"];
    [spin setDelegate: self];
    [spin setToValue: [NSNumber numberWithFloat: M_PI * 2.0]];
    [spin setDuration: 1.0];
    
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [spin setTimingFunction: timingFunction];
    
    [self.timeLabel.layer addAnimation: spin
                                forKey: @"spinAnimation"];
}

- (void)bounceTimeLabel
{
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath: @"transform"];
    CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D back = CATransform3DMakeScale(0.7, 0.7, 1);
    CATransform3D forward2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D back2 = CATransform3DMakeScale(0.9, 0.9, 1);
    
    [bounce setValues: @[[NSValue valueWithCATransform3D: CATransform3DIdentity],
                         [NSValue valueWithCATransform3D: forward],
                         [NSValue valueWithCATransform3D: back],
                         [NSValue valueWithCATransform3D: forward2],
                         [NSValue valueWithCATransform3D: back2],
                         [NSValue valueWithCATransform3D: CATransform3DIdentity]]];
    
    [bounce setDuration: 0.6];
    
    
    [[self.timeLabel layer] addAnimation: bounce
                                  forKey: @"bounceAnimation"];
    
}



@end
