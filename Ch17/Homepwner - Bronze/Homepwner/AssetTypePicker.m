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
#import "AddAssetTypeViewController.h"

@interface AssetTypePicker()

@property (nonatomic, strong) Class cellClass;
@property (nonatomic, strong) NSArray *filteredItems;

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

- (NSArray *)filteredItems
{
    if (!_filteredItems) {
        _filteredItems = [[ItemStore sharedStore] itemsOfAssetType: [self.item.assetType valueForKey: @"label"]];
    }
    return _filteredItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass: self.cellClass
           forCellReuseIdentifier: NSStringFromClass(self.cellClass)];
    
    UIBarButtonItem *addButtonItem;
    addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
                                                                  target: self
                                                                  action: @selector(addAssetType:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    [self.tableView reloadData];
}

- (void)addAssetType: (id)sender
{
    AddAssetTypeViewController *addAssetTypeViewController = [[AddAssetTypeViewController alloc] initWithNibName: nil
                                                                                                          bundle: nil];
    
    [self.navigationController pushViewController: addAssetTypeViewController
                                         animated: YES];
    
}

#pragma - mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0){
        count = [[[ItemStore sharedStore] allAssetTypes] count];
    }
    else {
        count = self.filteredItems.count;
    }
    return count;
}


- (void)configureCell:(UITableViewCell *)cell forFirstSectionUsingRow:(NSInteger)row
{
    NSArray *allAssets = [[ItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allAssets[row];
    
    NSString *assetLabel = [assetType valueForKey: @"label"];
    cell.textLabel.text = assetLabel;
    
    if (assetType == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)configureCell:(UITableViewCell *)cell forSecondSectionUsingRow:(NSInteger)row
{
    Item *item = self.filteredItems[row];
    cell.textLabel.text = item.itemName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass(self.cellClass)
                                                forIndexPath: indexPath];
    if (indexPath.section == 0){
        [self configureCell: cell forFirstSectionUsingRow: indexPath.row];
    }
    else {
        [self configureCell: cell forSecondSectionUsingRow: indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

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
    [tableView reloadData];
}

@end
