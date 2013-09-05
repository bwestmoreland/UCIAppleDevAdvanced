//
//  ColorSelectionView.m
//  TouchTracker
//
//  Created by Brent Westmoreland on 9/2/13.
//
//

#import "ColorSelectionView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ColorSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self blueButton];
        [self blackButton];
        [self yellowButton];
        [self greenButton];
        [self grayButton];
        [self lightGrayButton];
    }
    return self;
}

- (UIButton *)blueButton
{
    if (!_blueButton) {
        CGSize size = CGSizeMake(44.0f, 44.0f);
        _blueButton = [[UIButton alloc] initWithFrame: CGRectMake(16, 8, size.width, size.height)];
        [_blueButton setBackgroundColor: [UIColor blueColor]];
        [_blueButton addTarget: self
                        action: @selector(changeColor:)
              forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: _blueButton];
    }
    return _blueButton;
}

- (UIButton *)blackButton
{
    if (!_blackButton) {
        CGSize size = CGSizeMake(44.0f, 44.0f);
        _blackButton = [[UIButton alloc] initWithFrame: CGRectMake(64, 8, size.width, size.height)];
        [_blackButton setBackgroundColor: [UIColor blackColor]];
        [_blackButton addTarget: self
                        action: @selector(changeColor:)
              forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: _blackButton];
    }
    return _blackButton;
}

- (UIButton *)yellowButton
{
    if (!_yellowButton) {
        CGSize size = CGSizeMake(44.0f, 44.0f);
        _yellowButton = [[UIButton alloc] initWithFrame: CGRectMake(112, 8, size.width, size.height)];
        [_yellowButton setBackgroundColor: [UIColor yellowColor]];
        [_yellowButton addTarget: self
                         action: @selector(changeColor:)
               forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: _yellowButton];
    }
    return _yellowButton;
}

- (UIButton *)greenButton
{
    if (!_greenButton) {
        CGSize size = CGSizeMake(44.0f, 44.0f);
        _greenButton = [[UIButton alloc] initWithFrame: CGRectMake(160, 8, size.width, size.height)];
        [_greenButton setBackgroundColor: [UIColor greenColor]];
        [_greenButton addTarget: self
                         action: @selector(changeColor:)
               forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: _greenButton];
    }
    return _greenButton;
}

- (UIButton *)grayButton
{
    if (!_grayButton) {
        CGSize size = CGSizeMake(44.0f, 44.0f);
        _grayButton = [[UIButton alloc] initWithFrame: CGRectMake(208, 8, size.width, size.height)];
        [_grayButton setBackgroundColor: [UIColor grayColor]];
        [_grayButton addTarget: self
                        action: @selector(changeColor:)
              forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: _grayButton];
    }
    return _grayButton;
}

- (UIButton *)lightGrayButton
{
    if (!_lightGrayButton) {
        CGSize size = CGSizeMake(44.0f, 44.0f);
        _lightGrayButton = [[UIButton alloc] initWithFrame: CGRectMake(256, 8, size.width, size.height)];
        [_lightGrayButton setBackgroundColor: [UIColor lightGrayColor]];
        [_lightGrayButton addTarget: self
                            action: @selector(changeColor:)
                  forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: _lightGrayButton];
    }
    return _lightGrayButton;
}

- (UIColor *)selectedColor
{
    if (!_selectedColor){
        _selectedColor = [UIColor blackColor];
    }
    return _selectedColor;
}

- (void)changeColor: (UIButton *)button
{
    self.selectedColor = button.backgroundColor;
    self.layer.borderColor = [button.backgroundColor CGColor];
    self.layer.borderWidth = 3.0f;
}

@end
