//
//  WhereamiViewController.h
//  Whereami
//
//  Created by Brent Westmoreland on 6/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

@interface WhereamiViewController : UIViewController
<CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *worldView;
@property (weak, nonatomic) IBOutlet UITextField *locationTitleField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (IBAction)mapTypeChanged:(UISegmentedControl *)sender;

- (void)findLocation;
- (void)foundLocation: (CLLocation *)loc;

@end
