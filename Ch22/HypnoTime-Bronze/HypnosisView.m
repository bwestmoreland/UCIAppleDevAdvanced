//
//  HypnosisView.m
//  Hypnosister
//
//  Created by Brent Westmoreland on 6/11/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "HypnosisView.h"
#import <QuartzCore/QuartzCore.h>

@interface HypnosisView()

@property (nonatomic, strong) CALayer *boxLayer;
@property (nonatomic, strong) CALayer *boxSubLayer;

@end

@implementation HypnosisView

- (id)initWithCoder: (NSCoder *)aDecoder
{
    if (self = [super initWithCoder: aDecoder]){
        self.circleColor = [UIColor lightGrayColor];
        [self setBoxLayer:[CALayer layer]];
        [self.boxLayer setBounds: CGRectMake(0.0, 0.0, 85.0, 85.0)];
        
        [self.boxLayer setPosition: CGPointMake(160.0, 100.0)];
        
        UIColor *reddish = [UIColor colorWithRed: 1.0
                                           green: 0.0
                                            blue: 0.0
                                           alpha: 0.5];
        
        CGColorRef cgReddish = [reddish CGColor];
        [self.boxLayer setBackgroundColor: cgReddish];
        
        UIImage *layerImage = [UIImage imageNamed: @"Hypno.png"];
        CGImageRef image = [layerImage CGImage];
        [self.boxLayer setContents: (__bridge id)image];
        [self.boxLayer setContentsRect: CGRectMake( -0.1, -0.1, 1.2, 1.2)];
        [self.boxLayer setContentsGravity: kCAGravityResizeAspect];
        
        [self setBoxSubLayer: [CALayer layer]];
        [self.boxSubLayer setBounds: CGRectInset(self.boxLayer.bounds,
                                                 CGRectGetWidth(self.boxLayer.bounds) / 4,
                                                 CGRectGetHeight(self.boxLayer.bounds) / 4)];
        
        [self.boxSubLayer setPosition: CGPointMake(CGRectGetWidth(self.boxLayer.bounds) / 2,
                                                   CGRectGetHeight(self.boxLayer.bounds) / 2)];

        
        UIImage *layerSubImage = [UIImage imageNamed: @"Time"];
        CGImageRef subImage = [layerSubImage CGImage];
        [self.boxSubLayer setContents: (__bridge  id)subImage];
        [self.boxLayer addSublayer: self.boxSubLayer];
        
        
        
        [[self layer] addSublayer: self.boxLayer];
    }
    return self;
}

- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bounds = [self bounds];
    
    CGPoint center;
    
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    CGContextSetLineWidth(ctx, 10);
    
    [self.circleColor setStroke];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20 ) {
        CGContextAddArc(ctx, center.x, center.y, currentRadius, 0., M_PI * 2.,  YES);
        
        CGContextStrokePath(ctx);
    }
    
    NSString *text = @"You are getting sleepy";
    
    UIFont *font = [UIFont boldSystemFontOfSize: 28];
    
    CGRect textRect;
    
    textRect.size = [text sizeWithFont: font];
    
    textRect.origin.x = center.x - textRect.size.width / 2.0;
    textRect.origin.y = center.y - textRect.size.height / 2.0;
    
    [[UIColor blackColor] setFill];
    
    CGSize offset = CGSizeMake(4, 3);
    
    CGColorRef color = [[UIColor darkGrayColor] CGColor];
    
    CGContextSaveGState(ctx);
    
    CGContextSetShadowWithColor(ctx, offset, 2.0, color);
    
    [text drawInRect:textRect
            withFont:font];
    
    CGContextRestoreGState(ctx);

    CGContextStrokePath(ctx);
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: self];
    [self.boxLayer setPosition: point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: self];
    [CATransaction begin];
    [CATransaction setDisableActions: YES];

    [self.boxLayer setPosition: point];
    [CATransaction commit];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake){
        DLog(@"Device started shaking");
        [self setNeedsDisplay];
    }
}

@end
