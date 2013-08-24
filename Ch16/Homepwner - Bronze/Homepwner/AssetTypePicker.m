//
//  AssetTypePicker.m
//  Homepwner
//
//  Created by Brent Westmoreland on 8/24/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "AssetTypePicker.h"
#import "Item.h"
#import "ItemStore.h"

@interface AssetTypePicker()

@property (nonatomic, strong) Class cellClass;

@end

@implementation AssetTypePicker

- (id)init
{
    return [super initWithStyle: UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (Class)cellClass
{
    return [UITableViewCell class];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass: self.cellClass
           forCellReuseIdentifier: NSStringFromClass(self.cellClass)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ItemStore sharedStore] allAssetTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass(self.cellClass)
                                                forIndexPath: indexPath];
    
    NSArray *allAssets = [[ItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allAssets[indexPath.row];
    
    NSString *assetLabel = [assetType valueForKey: @"label"];
    cell.textLabel.text = assetLabel;
    
    if (assetType == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSArray *allAssets = [[ItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allAssets[indexPath.row];
    self.item.assetType = assetType;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [self.delegate didSelectItem: self];
    }
    else {
        [self.navigationController popViewControllerAnimated: YES];
    }

}

@end
