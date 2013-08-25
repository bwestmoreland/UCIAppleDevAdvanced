//
//  MapPoint.m
//  Whereami
//
//  Created by Brent Westmoreland on 6/10/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "MapPoint.h"
@interface MapPoint()

@property (readwrite, nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation MapPoint

- (id)init
{
    return [self initWithCoordinate: CLLocationCoordinate2DMake( 43.07, -89.32)
                              title: @"Home"];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                   title:(NSString *)title
{
    if (self = [super init]){
        _coordinate = coordinate;
        [self setTitle: title];
    }
    return self;
}

+ (NSString *)pointArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = documentDirectories[0];
    
    return [documentDirectory stringByAppendingPathComponent:@"points.archive"];
}

+ (BOOL)savePointsArray:(NSArray *)mapPoints
{
    NSString *path = [MapPoint pointArchivePath];
    
    return [NSKeyedArchiver archiveRootObject: mapPoints
                                       toFile: path];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: _title forKey: @"title"];
    [aCoder encodeDouble: _coordinate.longitude forKey: @"longitude"];
    [aCoder encodeDouble: _coordinate.latitude forKey: @"latitude"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self setTitle: [aDecoder decodeObjectForKey: @"title"]];
    double latitude = [aDecoder decodeDoubleForKey: @"latitude"];
    double longitude = [aDecoder decodeDoubleForKey: @"longitude"];
    
    [self setCoordinate: CLLocationCoordinate2DMake( latitude, longitude)];
    
    return self;
}

@end
