//
//  HypnosisViewController.h
//  HypnoTime
//
//  Created by Brent Westmoreland on 6/15/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

@interface HypnosisViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)colorChosen:(UISegmentedControl *)sender;

@end
