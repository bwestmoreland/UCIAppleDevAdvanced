//
//  WhereamiViewController.m
//  Whereami
//
//  Created by Brent Westmoreland on 6/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "WhereamiViewController.h"
#import "MapPoint.h"

typedef enum {
    kMapTypeStandard = 0,
    kMapTypeSatellite,
    kMapTypeHybrid
} kMapType;

@interface WhereamiViewController()

@end

@implementation WhereamiViewController

@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize locationTitleField = _locationTitleField;
@synthesize worldView = _worldView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        //Ch04 Bronze Challenge
        _locationManager.distanceFilter = 50.;
        
        //Ch04 Silver Challenge P1
        if ([CLLocationManager headingAvailable]){
            [_locationManager startUpdatingHeading];
        }
        NSString *path = [MapPoint pointArchivePath];
        
        [[self worldView] addAnnotations: [NSKeyedUnarchiver unarchiveObjectWithFile: path]];
    
    }
    return self;
}

- (void)findLocation
{
    [self.locationManager startUpdatingLocation];
    [self.activityIndicatorView startAnimating];
    
    self.locationTitleField.hidden = YES;
}

//Ch05 Gold Challenge

- (NSString *)dateToday
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    NSDate *date = [NSDate date];
    
    return [dateFormatter stringFromDate: date];
}

- (void)foundLocation:(CLLocation *)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];
    
    NSString *annotationTitle = [self.locationTitleField.text stringByAppendingFormat: @" - %@", [self dateToday]];
    
    MapPoint *point = [[MapPoint alloc] initWithCoordinate: coord
                                                     title: annotationTitle];
    
    [self.worldView addAnnotation: point];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    
    [self.worldView setRegion: region animated: YES];
    
    [self resetUI];
}

- (void)resetUI
{
    self.locationTitleField.text = @"";
    [self.activityIndicatorView stopAnimating];
    self.locationTitleField.hidden = NO;
    [self.locationManager stopUpdatingLocation];
}


//Ch05 Silver Challenge

-(void)mapTypeChanged:(UISegmentedControl *)sender
{
    NSParameterAssert(sender.selectedSegmentIndex >= 0);
    NSParameterAssert(sender.selectedSegmentIndex < 3);

    if (sender.selectedSegmentIndex == kMapTypeStandard ){

//Ch05 Bronze Challenge
        self.worldView.mapType = MKMapTypeStandard;
    }
    else if (sender.selectedSegmentIndex == kMapTypeSatellite){
        self.worldView.mapType = MKMapTypeSatellite;
    }
    else {
        self.worldView.mapType = MKMapTypeHybrid;
    }
}

#pragma mark UIViewController lifecycle

- (void)viewDidLoad
{
    [self configureWorldView];
}

- (void)nilUnsafeUnretainedObjects
{
    //These objects are unsafe_unretained and should be removed manually to avoid a memory leak
    self.locationManager.delegate = nil;
}

- (void)dealloc
{
    [self nilUnsafeUnretainedObjects];
}

#pragma mark CLLocationManagerDelegate

//Ch04 Silver Challenge P2
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    DLog(@"New Heading: %@", newHeading);
}

- (void)didUpdateLocation:(CLLocation *)location
{
    NSTimeInterval t = [[location timestamp] timeIntervalSinceNow];
    
    if (t < -180){
        //Cached data
        return;
    }
    [self foundLocation: location];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000 //then it's > iOS6

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
//    DLog(@"iOS6: %@", locations);
    [self didUpdateLocation:locations[0]];
}

#else //it's < iOS6 and should use the deprecated API

//TODO: Remove this after removal of iOS5 support

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    DLog(@"iOS5: %@", newLocation);
    [self didUpdateLocation: newLocation];
}

#endif

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    DLog(@"Did fail with error: %@", error);
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D location = [userLocation coordinate];
    DLog(@"Latitude: %f Longitude: %f", location.latitude, location.longitude );
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 250, 250);
    [mapView setRegion:region animated:YES];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self findLocation];
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark @property overrides and configuration

//activityIndicatorView

- (void)setActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView
{
    [self willChangeValueForKey:@"activityIndicatorView"];
    _activityIndicatorView = activityIndicatorView;
    [self didChangeValueForKey:@"activityIndicatorView"];
    [self configureActivityIndicatorView];
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    return _activityIndicatorView;
}

- (void)configureActivityIndicatorView
{
    self.activityIndicatorView.hidesWhenStopped = YES;
}

//locationTitleField

- (void)setLocationTitleField:(UITextField *)locationTitleField
{
    [self willChangeValueForKey:@"locationTitleField"];
    _locationTitleField = locationTitleField;
    [self didChangeValueForKey:@"locationTitleField"];
    [self configureLocationTitleTextField];
}

- (UITextField *)locationTitleField
{
    return _locationTitleField;
}

- (void)configureLocationTitleTextField
{
    self.locationTitleField.placeholder = @"Enter Location Name";
    self.locationTitleField.returnKeyType = UIReturnKeyDone;
}


//worldView

- (void)setWorldView:(MKMapView *)worldView
{
    [self willChangeValueForKey:@"worldView"];
    _worldView = worldView;
    [self didChangeValueForKey:@"worldView"];
    [self configureWorldView];
}

- (MKMapView *)worldView
{
    return _worldView;
}

- (void)configureWorldView
{
    self.worldView.showsUserLocation = YES;
}

@end
