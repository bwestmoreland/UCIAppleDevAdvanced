//
//  ImageViewController.m
//  Homepwner
//
//  Created by Brent Westmoreland on 6/21/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "ImageViewController.h"

@implementation ImageViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    CGSize size = self.image.size;
    
    self.scrollView.contentSize = size;
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.minimumZoomScale = .5;
    
    [self.imageView setFrame: CGRectMake(0., 0., size.width, size.height)];
    
    self.imageView.image = self.image;
    
    CGPoint center;
    
    center.x = self.image.size.width / 2.0;
    center.y = self.image.size.height / 2.0;
    
    CGRect zoomRect = [self zoomRectForScrollView: self.scrollView withScale: 0.5 withCenter: center];
    
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}



@end
