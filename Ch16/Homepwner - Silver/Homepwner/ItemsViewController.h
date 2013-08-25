//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Brent Westmoreland on 6/15/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

@interface ItemsViewController : UITableViewController
<UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *imagePopover;

- (IBAction)addNewItem:(UIButton *)sender;

- (void)showImage: (id)sender
      atIndexPath: (NSIndexPath *)indexPath;

@end
