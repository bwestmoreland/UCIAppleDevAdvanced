//
//  HypnosisViewController.m
//  HypnoTime
//
//  Created by Brent Westmoreland on 6/15/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"

typedef enum {
    kCircleColorRed = 0,
    kCircleColorGreen,
    kCircleColorBlue
} kCircleColor;

@implementation HypnosisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
    
        [self setTitle: @"Hypnosis"];
        
        [[self tabBarItem] setImage: [UIImage imageNamed: @"Hypno"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self colorChosen: self.segmentedControl];
}

- (IBAction)colorChosen:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == kCircleColorRed) {
        [(HypnosisView *)self.view setCircleColor:[UIColor lightGrayColor]];
    }
    else if (sender.selectedSegmentIndex == kCircleColorGreen) {
        [(HypnosisView *)self.view setCircleColor:[UIColor greenColor]];
    }
    else {
        [(HypnosisView *)self.view setCircleColor:[UIColor blueColor]];
    }
}
@end
