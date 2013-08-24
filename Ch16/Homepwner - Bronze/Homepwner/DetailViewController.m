//
//  DetailViewController.m
//  Homepwner
//
//  Created by Brent Westmoreland on 6/16/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "DetailViewController.h"
#import "ImageStore.h"
#import "Item.h"
#import "ItemStore.h"

@implementation DetailViewController

- (id)initForNewItem: (BOOL)isNew
{
    if ((self = [super initWithNibName:@"DetailView" bundle: nil]) && isNew){
        UIBarButtonItem *doneItem = nil;
        doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                 target: self
                                                                 action: @selector(save:)];
        self.navigationItem.rightBarButtonItem = doneItem;
        
        UIBarButtonItem *cancelItem = nil;
        cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                   target: self
                                                                   action: @selector(cancel:)];
        self.navigationItem.leftBarButtonItem = cancelItem;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName: @"Wrong initializor"
                                   reason: @"Use initForNewItem:"
                                 userInfo: nil];
    return nil;
}

- (void)setItem:(Item *)item
{
    _item = item;
    [self setTitle: item.itemName];
}

- (IBAction)takePicture:(UIBarButtonItem *)sender
{
    if ([self.imagePickerPopover isPopoverVisible]) {
        [self.imagePickerPopover dismissPopoverAnimated: YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        self.imagePickerPopover.delegate = self;
        
        [self.imagePickerPopover presentPopoverFromBarButtonItem: sender
                                        permittedArrowDirections: UIPopoverArrowDirectionAny
                                                        animated: YES];
    }
    else {
        [self presentViewController: imagePicker
                           animated: YES
                         completion: nil];        
    }
    
}

- (void)save: (id)sender
{
    [self.presentingViewController dismissViewControllerAnimated: YES completion: self.dismissBlock];
}

- (void)cancel: (id)sender
{
    [[ItemStore sharedStore] removeItem: self.item];
    [self.presentingViewController dismissViewControllerAnimated: YES completion: self.dismissBlock];
}


//Implement Ch12 Silver Challenge

- (IBAction)deletePicture: (UIBarButtonItem *)sender
{
    if (self.item.imageKey) {
        [[ImageStore sharedStore] deleteImageForKey: self.item.imageKey];
        self.item.imageKey = nil;
        self.imageView.image = nil;
    }
}

- (IBAction)showAssetTypePicker:(UIButton *)sender
{
    [self.view endEditing: YES];
    AssetTypePicker *assetTypePicker = [[AssetTypePicker alloc] init];
    assetTypePicker.delegate = self;
    assetTypePicker.item = self.item;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.assetPopover = [[UIPopoverController alloc] initWithContentViewController: assetTypePicker];
        self.assetPopover.delegate = self;
        [self.assetPopover presentPopoverFromRect: self.assetTypeButton.bounds
                                           inView: self.view
                         permittedArrowDirections: UIPopoverArrowDirectionAny
                                         animated: YES];
    }
    else {
        [self.navigationController pushViewController: assetTypePicker
                                             animated: YES];
        
    }
}


- (void)dismissKeyboard
{
    [self.view endEditing: YES];
}

#pragma mark - AssetTypePickerDelegate

- (void)didSelectItem: (AssetTypePicker *)assetPicker;
{
    NSString *assetType = [self.item.assetType valueForKey: @"label"];
    [self.assetTypeButton setTitle: assetType forState: UIControlStateNormal];
    [self.assetPopover dismissPopoverAnimated: YES];
    self.assetPopover = nil;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [self.item imageKey];
    
    if (oldKey) {
        [[ImageStore sharedStore] deleteImageForKey: oldKey];
    }
    
    UIImage* image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailDataFromImage: image];
    
    self.imageView.image = image;
    
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    
    NSString *key = (__bridge NSString *)uniqueIdString;
    
    self.item.imageKey = key;
    
    [[ImageStore sharedStore] setImage: image forKey: key];
    
    CFRelease(newUniqueId);
    CFRelease(uniqueIdString);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated: YES completion: nil];
    }
    else {
        [self.imagePickerPopover dismissPopoverAnimated: YES];
        self.imagePickerPopover = nil;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"Popover dismissed");
    self.imagePickerPopover = nil;
    self.assetPopover = nil;
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    UIColor *backgroundColor = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        backgroundColor = [UIColor colorWithRed: 0.875 green: 0.88 blue: 0.91 alpha: 1.];
    }
    else {
        backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    [[self view] setBackgroundColor: backgroundColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                          action: @selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO; //Allows other tappable areas to work
    
    [self.view addGestureRecognizer: tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.nameField.text = self.item.itemName;
    self.serialField.text = self.item.serialNumber;
    
    NSString *valueInDollars = [NSString stringWithFormat:@"%d", self.item.valueInDollars];
    self.valueField.text = valueInDollars;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    NSDate *dateCreated = [NSDate dateWithTimeIntervalSinceReferenceDate: self.item.dateCreated];
    
    self.dateLabel.text = [dateFormatter stringFromDate: dateCreated];
    
    if (self.item.imageKey) {
        UIImage *image = [[ImageStore sharedStore] imageForKey: self.item.imageKey];
        self.imageView.image = image;
    }
    else {
        self.imageView.image = nil;
    }
    
    NSString *typeLabel = [self.item.assetType valueForKey: @"label"];
    if (!typeLabel){
        typeLabel = @"None";
    }
    [self.assetTypeButton setTitle: [NSString stringWithFormat:@"Title: %@", typeLabel]
                          forState: UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear: animated];
    
    [self.view endEditing: YES];
    
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
}

- (void)viewDidUnload {
    [self setAssetTypeButton:nil];
    [super viewDidUnload];
}
@end
