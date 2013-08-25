//
//  WhereamiViewSpec.m
//  Whereami
//
//  Created by Brent Westmoreland on 6/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "Kiwi.h"
#import "WhereamiViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface FakeMKUserLocation : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation FakeMKUserLocation

@synthesize coordinate = _coordinate;

@end

WhereamiViewController *(^whereamiVC)(void) = ^WhereamiViewController *(void){
    WhereamiViewController *tempVC;
    tempVC = [[WhereamiViewController alloc] initWithNibName: nil
                                                      bundle: nil];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:bounds];
    [tempVC.view addSubview: mapView];
    tempVC.worldView = mapView;
    
    UITextField *textField = [[UITextField alloc] init];
    [tempVC.view addSubview: textField];
    tempVC.locationTitleField = textField;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    [tempVC.view addSubview: activityIndicatorView];
    tempVC.activityIndicatorView = activityIndicatorView;
    
    return tempVC;
};


SPEC_BEGIN(WhereamiViewSpec)

describe(@"Where Am I View Controller", ^{
    __block WhereamiViewController *viewController;
    
    beforeEach(^{ // Occurs before each enclosed "it"
        viewController = whereamiVC();
    });
    
    afterEach(^{ // Occurs after each enclosed "it"
        viewController = nil;
    });
    
    context(@"after being initialized", ^{
        
        it(@"have a location manager", ^{
            [viewController.locationManager shouldNotBeNil];
            CLLocationAccuracy accuracy = viewController.locationManager.desiredAccuracy;
            [[theValue(accuracy) should] equal:theValue(kCLLocationAccuracyBest)];
        });

        it(@"should be a delegate for the location manager", ^{
            id <CLLocationManagerDelegate> delegate = viewController.locationManager.delegate;
            [[viewController should] equal:delegate];
        });
        
        it(@"should have a worldView of type MKMapView", ^{
            [viewController.worldView shouldNotBeNil];
            [[viewController.worldView should] beKindOfClass: [MKMapView class]];
            [[theValue(viewController.worldView.showsUserLocation) should] beYes];
        });
        
        it(@"should have an activityIndicator", ^{
            [viewController.activityIndicatorView shouldNotBeNil];
            [[viewController.activityIndicatorView should] beKindOfClass: [UIActivityIndicatorView class]];
            [[theValue(viewController.activityIndicatorView.hidesWhenStopped) should] beTrue];
        });
        
        it(@"should have a locationTitleField", ^{
            [viewController.locationTitleField shouldNotBeNil];
            [[viewController.locationTitleField should] beKindOfClass: [UITextField class]];
            [[viewController.locationTitleField.placeholder should] equal:@"Enter Location Name"];
            id done = theValue(UIReturnKeyDone);
            [[theValue(viewController.locationTitleField.returnKeyType) should] equal: done];
        });
    });
    
    context(@"as the delegate for a location manager", ^{
        
        it(@"should implement locationManager: didUpdateLocations", ^{
            [[theBlock(^{
                [viewController locationManager: nil didUpdateLocations: nil];
            }) shouldNot] raise]; //an exception
        });
        
        it(@"should implement locationManager: didFailWithError", ^{
            [[theBlock(^{
                [viewController locationManager: nil didFailWithError: nil];
            }) shouldNot] raise]; //an exception
        });
        
        it(@"should implement locationManager: didUpdateHeading", ^{
            [[theBlock(^{
                [viewController locationManager: nil didUpdateHeading: nil];
            }) shouldNot] raise]; //an exception
        });
        
        it(@"should set the locationmanager's delegate to nil on dealloc", ^{
        //TODO: learn how to actually verify with Kiwi that an unsafe_unretained object is removed in dealloc
            
        });
    });
    
    context(@"as the delegate for map view", ^{
        
        it(@"should implement the mapView: didUpdateUserLocation: method", ^{
            [[theBlock(^{
                [viewController mapView: nil didUpdateUserLocation: nil];
            }) shouldNot] raise]; //an exception
        });
        
        it(@"should zoom the map view", ^{
            CLLocationCoordinate2D london = { 51.509, -0.133 };
            
            FakeMKUserLocation *fakeUserLocation = [[FakeMKUserLocation alloc] init];
            fakeUserLocation.coordinate = london;
            
            [viewController mapView: viewController.worldView
              didUpdateUserLocation: (MKUserLocation *)fakeUserLocation];
            
            [[theValue(viewController.worldView.region.center.latitude) should] equal: london.latitude
                                                                            withDelta: 0.0001];
            [[theValue(viewController.worldView.region.center.longitude) should] equal: london.longitude
                                                                            withDelta: 0.0001];
        });
        
    });
    
    context(@"as a UITextField delegate", ^{
        it(@"should conform to protocol UITextFieldDelgate", ^{
            [[viewController should] conformToProtocol: @protocol(UITextFieldDelegate)];
        });
        
        it(@"should implement textFieldShouldReturn: ", ^{
            [[theBlock(^{
                [viewController textFieldShouldReturn: nil];
            }) shouldNot] raise]; //an exception
        });
    });
    
    context(@"after entering a location", ^{
        beforeEach(^{ // Occurs before each enclosed "it"
            viewController.locationTitleField.text = @"Some Text";
        });
        it(@"should be able to find a location", ^{
            
        });
    });
});


SPEC_END
