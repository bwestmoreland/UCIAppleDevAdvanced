//
//  MapPointSpec.m
//  Whereami
//
//  Created by Brent Westmoreland on 6/10/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "Kiwi.h"
#import "MapPoint.h"

//MapPoint *(^mapPoint)(CLLocationCoordinate2D coord, NSString *title) = ^MapPoint *(CLLocationCoordinate2D coord, NSString *title) {
//    MapPoint *point = [[MapPoint alloc] initWithCoordinate: coord title: title];
//    
//    return point;
//};

SPEC_BEGIN(MapPointSpec)


describe(@"Map Point", ^{
    __block MapPoint *point;
    CLLocationCoordinate2D london = { 51.509, -0.133 };
    
    beforeEach(^{ // Occurs before each enclosed "it"
        point = [[MapPoint alloc] initWithCoordinate: london title: @"London"];
    });
    
    afterEach(^{ // Occurs after each enclosed "it"
        point = nil;
    });
    
    context(@"after initialization", ^{
        it(@"should have a coordinate", ^{
            [[theValue(point.coordinate.latitude) should] equal: london.latitude
                                                      withDelta: .0001];
            [[theValue(point.coordinate.longitude) should] equal: london.longitude
                                                      withDelta: .0001];
        });
        it(@"should have a title", ^{
            [[point.title should] equal: @"London"];
        });
    });
    
    context(@"as an MKAnnotation", ^{
        it(@"should conform to the MKAnnotation protocol", ^{
            [[point should] conformToProtocol: @protocol(MKAnnotation)];
        });
    });
});

SPEC_END