//
//  AddAssetTypeViewController.m
//  Homepwner
//
//  Created by Brent Westmoreland on 8/24/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "AddAssetTypeViewController.h"
#import "ItemStore.h"

@interface AddAssetTypeViewController ()

@end

@implementation AddAssetTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTapGestureThatDismissesKeyboard];
}

- (void)addTapGestureThatDismissesKeyboard
{
    UITapGestureRecognizer *tap;
    tap = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                  action: @selector(dismissKeyboard:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer: tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAssetTypeTextField:nil];
    [super viewDidUnload];
}

#pragma mark - Keyboard

- (void)dismissKeyboard: (id)sender
{
    [self.view endEditing: YES];
}

#pragma mark - AssetType

- (IBAction)addAssetCategory: (UIButton *)sender
{
    [[ItemStore sharedStore] addAssetType: self.assetTypeTextField.text];
    [self.navigationController popViewControllerAnimated: YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    [self dismissKeyboard: self];
    return YES;
}

@end
