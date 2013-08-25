//
//  ImageStore.h
//  Homepwner
//
//  Created by Brent Westmoreland on 6/16/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

@interface ImageStore : NSObject

+ (ImageStore *)sharedStore;

- (void)setImage: (UIImage *)image forKey: (NSString *)key;
- (UIImage *)imageForKey: (NSString *)key;
- (void)deleteImageForKey: (NSString *)key;
- (NSString *)imagePathForKey: (NSString *)key;

@end
