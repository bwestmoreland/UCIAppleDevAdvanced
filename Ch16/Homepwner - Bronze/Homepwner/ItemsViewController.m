//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Brent Westmoreland on 6/15/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "ItemsViewController.h"
#import "DetailViewController.h"
#import "ImageViewController.h"
#import "ItemStore.h"
#import "ImageStore.h"
#import "Item.h"
#import "ItemCell.h"

@implementation ItemsViewController

- (id)init
{
    if (self = [super initWithStyle: UITableViewStyleGrouped]) {
        [self setTitle: @"Homepwner"];
        
        UIBarButtonItem *rightBarButton;
        
        rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
                                                                      target: self
                                                                      action: @selector(addNewItem:)];
        
        [[self navigationItem] setRightBarButtonItem: rightBarButton];
        
        [[self navigationItem] setLeftBarButtonItem: [self editButtonItem]];
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}


- (void)addNewItem:(UIButton *)sender
{
    Item *item = [[ItemStore sharedStore] createItem];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem: YES];
    detailViewController.item = item;
    
    [detailViewController setDismissBlock:^{
        [self.tableView reloadData];
    }];
    
    UINavigationController *navController = nil;
    navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController: navController animated: YES completion: nil];
}

- (void)showImage:(id)sender atIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        Item * item = [[ItemStore sharedStore] allItems][indexPath.row];
        
        NSString *imageKey = [item imageKey];
        
        UIImage *image = [[ImageStore sharedStore] imageForKey: imageKey];
        
        if (!image) return;
        
        CGRect rect = [self.view convertRect: [sender bounds] fromView: sender];
        
        ImageViewController *imageController = [[ImageViewController alloc] init];
        
        imageController.image = image;
        
        self.imagePopover = [[UIPopoverController alloc] initWithContentViewController: imageController];
        
        self.imagePopover.delegate = self;
        self.imagePopover.popoverContentSize = CGSizeMake(600., 600.);
        
        [self.imagePopover presentPopoverFromRect: rect
                                           inView: self.view
                         permittedArrowDirections: UIPopoverArrowDirectionAny
                                         animated: YES];
    }
}


-  (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate


- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem: NO];
    
    NSArray *items = [[ItemStore sharedStore] allItems];
    
    Item *item = items[indexPath.row];
    
    detailViewController.item = item;
    
    [self.navigationController pushViewController: detailViewController
                                         animated: YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0) {
        count = [[[ItemStore sharedStore] allItems] count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([ItemCell class])];
    
    [cell setController: self];
    [cell setTableView: tableView];
    
    Item *item = [[[ItemStore sharedStore] allItems] objectAtIndex: indexPath.row];
    
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    
    cell.valueLabel.textColor = (item.valueInDollars > 50) ? [UIColor greenColor] : [UIColor redColor];
    
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    cell.thumbnailView.image = item.thumbnail;
    
    return cell;
}

-   (void)tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ItemStore *store = [ItemStore sharedStore];
        NSArray *items = [store allItems];
        Item *item = items[indexPath.row];
        [store removeItem: item];
        
        [tableView deleteRowsAtIndexPaths: @[indexPath]
                         withRowAnimation: UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{

    [[ItemStore sharedStore] moveItemAtIndex: sourceIndexPath.row
                                     toIndex: destinationIndexPath.row];

}

#pragma mark - UIView lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName: @"ItemCell" bundle: nil];
    
    [self.tableView registerNib: nib
         forCellReuseIdentifier: NSStringFromClass([ItemCell class])];
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self.imagePopover dismissPopoverAnimated: YES];
    self.imagePopover = nil;
}

@end
