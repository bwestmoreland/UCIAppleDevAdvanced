//
//  ItemCell.h
//  Homepwner
//
//  Created by Brent Westmoreland on 6/20/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

@interface ItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) id controller;
@property (weak, nonatomic) UITableView *tableView;


- (IBAction)showImage:(UIButton *)sender;

@end
