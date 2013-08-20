//
//  ItemStore.m
//  Homepwner
//
//  Created by Brent Westmoreland on 6/15/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "ItemStore.h"
#import "ImageStore.h"
#import "Item.h"


@interface ItemStore()
{
    NSMutableArray *_allItems;
}

@end

@implementation ItemStore

+ (ItemStore *)sharedStore
{
    static ItemStore *_sharedStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [[ItemStore alloc] init];
    });

    return _sharedStore;
}

- (id)init
{
    if (self = [super init]) {
        
        NSString *path = [self itemArchivePath];
        _allItems = [NSKeyedUnarchiver unarchiveObjectWithFile: path];
        
        if (!_allItems) _allItems = [NSMutableArray array];
    }
    
    return self;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = documentDirectories[0];
    
    return [documentDirectory stringByAppendingPathComponent: @"items.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject: _allItems
                                       toFile: path];
}

- (Item *)createItem
{
    Item *item = [[Item alloc] init];
    
    [_allItems addObject: item];
    
    return item;
}

- (NSArray *)allItems
{
    return [_allItems copy];
}

-(void)removeItem:(Item *)item
{
    NSString *key = item.imageKey;
    [[ImageStore sharedStore] deleteImageForKey: key];
    [_allItems removeObjectIdenticalTo: item];
}

- (void)moveItemAtIndex:(int)oldIndex
                toIndex:(int)newIndex
{
    if (oldIndex == newIndex) {
        return;
    }
    
    Item *item = [_allItems objectAtIndex: oldIndex];
    
    [self removeItem: item];
    
    if (newIndex > _allItems.count) newIndex = _allItems.count;
    
    [_allItems insertObject: item atIndex: newIndex];
    
    NSLog(@"Moved from %d to %d", oldIndex, newIndex);
    
}
@end
