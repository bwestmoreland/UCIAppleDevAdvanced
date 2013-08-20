//
//  ImageViewController.h
//  Homepwner
//
//  Created by Brent Westmoreland on 6/21/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

@interface ImageViewController : UIViewController
<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIImage *image;

@end
