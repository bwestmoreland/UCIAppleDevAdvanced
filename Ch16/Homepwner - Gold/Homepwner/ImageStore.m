//
//  ImageStore.m
//  Homepwner
//
//  Created by Brent Westmoreland on 6/16/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "ImageStore.h"

@implementation ImageStore
{
    NSMutableDictionary *dictionary;
}

+ (ImageStore *)sharedStore
{
    static ImageStore *_sharedStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [[ImageStore alloc] init];
    });
    
    return _sharedStore;
}

- (id)init
{
    if (self = [super init]) {
        dictionary = [NSMutableDictionary dictionary];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver: self
                   selector: @selector(clearCache:)
                       name: UIApplicationDidReceiveMemoryWarningNotification
                     object: nil];
    }
    return self;
}

- (void)clearCache: (id)sender
{
    NSLog(@"Flushing %d images out of cache", [dictionary count]);
    [dictionary removeAllObjects];
}

- (void)setImage:(UIImage *)image forKey: (NSString *)key
{
    dictionary[key] = image;
    
    NSString *imagePath = [self imagePathForKey: key];
    
    NSData *buffer = UIImagePNGRepresentation(image);
    
    [buffer writeToFile: imagePath atomically: YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    UIImage *result = dictionary[key];
    
    if (!result) {
        result = [UIImage imageWithContentsOfFile: [self imagePathForKey: key]];
        
        if (result) {
            [dictionary setObject: result forKey: key];
        }
        else {
            NSLog(@"ERROR: unable to find %@", [self imagePathForKey: key]);
        }
    }
    
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [dictionary removeObjectForKey: key];
    
    NSString *path = [self imagePathForKey: key];
    [[NSFileManager defaultManager] removeItemAtPath: path
                                               error: NULL];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = documentDirectories[0];

    return [documentDirectory stringByAppendingPathComponent: key];
}


@end
