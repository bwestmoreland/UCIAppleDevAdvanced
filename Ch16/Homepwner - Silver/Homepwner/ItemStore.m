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
#import <CoreData/CoreData.h>

@interface ItemStore()
{
    NSMutableArray *_allItems;
    NSMutableArray *_allAssetTypes;
    NSManagedObjectContext *_context;
    NSManagedObjectModel *_model;
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
        
        _model = [NSManagedObjectModel mergedModelFromBundles: nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: _model];
        
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath: path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType: NSSQLiteStoreType
                               configuration: nil
                                         URL: storeURL
                                     options: nil
                                       error: &error]){
            
            [NSException raise: @"Open Failed" format: @"Reason %@", [error localizedDescription]];
        }
        
        _context = [[NSManagedObjectContext alloc] init];
        
        [_context setPersistentStoreCoordinator: psc];
        
        [_context setUndoManager: nil];
        
        [self loadAllItems];
        
    }
    
    return self;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = documentDirectories[0];
    
    return [documentDirectory stringByAppendingPathComponent: @"store.data"];
}

- (BOOL)saveChanges
{
    NSError *error = nil;
    
    BOOL successful = [_context save: &error];
    
    if (!successful){
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    
    return successful;
}

- (Item *)createItem
{
    double order;
    if (_allItems.count == 0){
        order = 1.0;
    }
    else {
        order = [[_allItems lastObject] orderingValue] + 1.0;
    }
    
    NSLog(@"Adding after %d items, order = %.2f", _allItems.count, order);
    Item *item = [NSEntityDescription insertNewObjectForEntityForName: @"Item"
                                               inManagedObjectContext: _context];
    [item setOrderingValue: order];
    
    [_allItems addObject: item];
    
    return item;
}

- (void)loadAllItems
{
    if (!_allItems){
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [[_model entitiesByName] objectForKey: @"Item"];
        [request setEntity: entity];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"orderingValue"
                                                                         ascending: YES];
        
        [request setSortDescriptors: @[sortDescriptor]];
        
        NSError *error;
        
        NSArray *results = [_context executeFetchRequest: request error: &error];
        
        if (!results){
            [NSException raise: @"Fetch failed"
                        format: @"Reason: %@", [error localizedDescription]];
        }
        _allItems = [results mutableCopy];
    }
}

- (NSArray *)allItems
{
    return [_allItems copy];
}

- (void)addBaseAssetTypes
{
    if (_allAssetTypes.count == 0) {
        [self addAssetType: @"Furniture"];
        [self addAssetType: @"Electronics"];
        [self addAssetType: @"Jewelry"];
    }
}

- (NSArray *)allAssetTypes
{
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [[_model entitiesByName] objectForKey: @"AssetType"];
        [request setEntity: entity];
        
        NSError *error;
        NSArray *result = [_context executeFetchRequest: request error: &error];
        if (!result){
            [NSException raise: @"Fetch failed"
                        format: @"Reason: %@", [error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    
    [self addBaseAssetTypes];
    return _allAssetTypes;
}

- (void)addAssetType: (NSString *)category
{
    NSManagedObject *type;
    
    type = [NSEntityDescription insertNewObjectForEntityForName: @"AssetType"
                                         inManagedObjectContext: _context];
    
    [type setValue: category forKey: @"label"];
    [_allAssetTypes addObject: type];
}


- (void)removeItem:(Item *)item
{
    NSString *key = item.imageKey;
    [[ImageStore sharedStore] deleteImageForKey: key];
    [_context deleteObject: item];
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
    
    double lowerBound = 0.0;
    
    if (newIndex > 0){
        lowerBound = [_allItems[newIndex -1] orderingValue];
    }
    else {
        lowerBound = [_allItems[1] orderingValue] -2.0;
    }
    
    double upperBound = 0.0;
    
    if (newIndex < _allItems.count -1) {
        upperBound = [_allItems[newIndex + 1] orderingValue];
    }
    else {
        upperBound = [_allItems[newIndex -1] orderingValue] + 2.0;
    }
    
    double newOrderValue = lowerBound + upperBound / 2.0;
    
    
    NSLog(@"Moving to new order value: %f", newOrderValue);
    
    [item setOrderingValue: newOrderValue];
    
}


@end
