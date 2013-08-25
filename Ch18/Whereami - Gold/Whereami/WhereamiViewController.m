//
//  WhereamiViewController.m
//  Whereami
//
//  Created by Brent Westmoreland on 6/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "WhereamiViewController.h"
#import "MapPoint.h"

NSString *const WhereAmIMapTypePrefKey = @"WhereAmIMapTypePrefKey";
NSString *const WhereAmILatitudePrefKey = @"WhereAmILatitudePrefKey";
NSString *const WhereAmILongitudePrefKey = @"WhereAmILongitudePrefKey";

@interface WhereamiViewController()

@end

@implementation WhereamiViewController

@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize locationTitleField = _locationTitleField;
@synthesize worldView = _worldView;

+ (void)saveToDefaultsWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude
{
    DLog(@"Saving to defaults: %f, %f", latitude, longitude);
    [[NSUserDefaults standardUserDefaults] setDouble: latitude
                                              forKey: WhereAmILatitudePrefKey];
    
    [[NSUserDefaults standardUserDefaults] setDouble: longitude
                                              forKey: WhereAmILongitudePrefKey];
}

+ (void)initialize
{
    NSDictionary *maptype = @{ WhereAmIMapTypePrefKey: [NSNumber numberWithInt: 1] };
    [[NSUserDefaults standardUserDefaults] registerDefaults: maptype];
    
    CLLocationDegrees latitude = 51.509980;
    CLLocationDegrees longitude = -0.133700;
    
    NSDictionary *location = @{ WhereAmILatitudePrefKey: [NSNumber numberWithDouble: latitude],
                                WhereAmILongitudePrefKey: [NSNumber numberWithDouble: longitude]};
    [[NSUserDefaults standardUserDefaults] registerDefaults: location];
}

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

- (NSString *)dateToday
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    NSDate *date = [NSDate date];
    
    return [dateFormatter stringFromDate: date];
}

- (void)zoomToPoint:(CLLocationCoordinate2D)coord
{
    DLog(@"Zooming to Point: %f, %f", coord.latitude, coord.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [self.worldView setRegion: region animated: YES];
}

- (void)foundLocation:(CLLocation *)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];
    
    [WhereamiViewController saveToDefaultsWithLatitude: coord.latitude andLongitude: coord.longitude];
    
    NSString *annotationTitle = [self.locationTitleField.text stringByAppendingFormat: @" - %@", [self dateToday]];
    
    MapPoint *point = [[MapPoint alloc] initWithCoordinate: coord
                                                     title: annotationTitle];
    
    [self.worldView addAnnotation: point];
    
    [self zoomToPoint:coord];
    
    [self resetUI];
}

- (void)resetUI
{
    self.locationTitleField.text = @"";
    [self.activityIndicatorView stopAnimating];
    self.locationTitleField.hidden = NO;
    [self.locationManager stopUpdatingLocation];
}

-(void)mapTypeChanged:(UISegmentedControl *)sender
{
    NSParameterAssert(sender.selectedSegmentIndex >= 0);
    NSParameterAssert(sender.selectedSegmentIndex < 3);
    
    [[NSUserDefaults standardUserDefaults] setInteger: [sender selectedSegmentIndex]
                                               forKey: WhereAmIMapTypePrefKey];

    self.worldView.mapType = sender.selectedSegmentIndex;
}

#pragma mark UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureWorldView];
    
    NSInteger mapTypeValue = [[NSUserDefaults standardUserDefaults] integerForKey: WhereAmIMapTypePrefKey];
    
    [self.mapTypeSegmentedControl setSelectedSegmentIndex: mapTypeValue];
    [self mapTypeChanged: self.mapTypeSegmentedControl];
    
    CLLocationDegrees latitude = [[NSUserDefaults standardUserDefaults] doubleForKey: WhereAmILatitudePrefKey];
    CLLocationDegrees longitude = [[NSUserDefaults standardUserDefaults] doubleForKey: WhereAmILongitudePrefKey];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude: latitude longitude: longitude];
    
    [self zoomToPoint: location.coordinate];
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
    DLog();
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
    [self didUpdateLocation:locations[0]];
}

#else //it's < iOS6 and should use the deprecated API

//TODO: Remove this after removal of iOS5 support

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
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
    [self zoomToPoint: location];
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
