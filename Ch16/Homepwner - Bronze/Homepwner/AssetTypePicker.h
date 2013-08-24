//
//  AssetTypePicker.h
//  Homepwner
//
//  Created by Brent Westmoreland on 8/24/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//
@class Item;
@protocol AssetTypePickerDelegate;

@interface AssetTypePicker : UITableViewController

@property (strong, nonatomic) Item *item;
@property (weak, nonatomic) id <AssetTypePickerDelegate> delegate;

@end

@protocol AssetTypePickerDelegate <NSObject>

- (void)didSelectItem: (AssetTypePicker *)assetTypePicker;

@end
