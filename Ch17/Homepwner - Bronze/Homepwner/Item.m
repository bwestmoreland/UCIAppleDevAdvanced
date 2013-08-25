//
//  Item.m
//  Homepwner
//
//  Created by Brent Westmoreland on 8/24/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "Item.h"


@implementation Item

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic imageKey;
@dynamic thumbnailData;
@dynamic thumbnail;
@dynamic orderingValue;
@dynamic assetType;

- (void)awakeFromFetch
{
    [super awakeFromFetch];
    
    UIImage *thumbNail = [UIImage imageWithData: [self thumbnailData]];
    [self setPrimitiveValue: thumbNail forKey: @"thumbnail"];
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceReferenceDate];
    [self setDateCreated: timeInterval];
}

- (void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize originalSize = [image size];
    CGRect newRect = CGRectMake(0., 0., 40., 40.);
    
    float ratio = MAX(newRect.size.width / originalSize.width,
                      newRect.size.height / originalSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: newRect
                                                    cornerRadius: 5.0];
    
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * originalSize.width;
    projectRect.size.height = ratio * originalSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.;
    
    [image drawInRect: projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    [self setThumbnail: smallImage];
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData: data];
    
    UIGraphicsEndImageContext();
}


@end
