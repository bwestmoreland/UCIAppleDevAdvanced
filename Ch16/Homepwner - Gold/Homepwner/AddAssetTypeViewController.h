//
//  AddAssetTypeViewController.h
//  Homepwner
//
//  Created by Brent Westmoreland on 8/24/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAssetTypeViewController : UIViewController
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *assetTypeTextField;
- (IBAction)addAssetCategory:(UIButton *)sender;

@end
