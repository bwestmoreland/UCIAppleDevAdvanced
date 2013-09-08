//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
<UIWebViewDelegate>

@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *webView = [[UIWebView alloc] initWithFrame: screenFrame];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    
    self.view = webView;
    
    self.toolBar.items = @[self.backButton, self.forwardButton];
    
    [self.view addSubview:self.toolBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}



- (UIWebView *)webView
{
    return (UIWebView *)self.view;
}

- (UIToolbar *)toolBar
{
    if (!_toolBar) {
        CGSize toolbarSize = CGSizeMake(self.view.bounds.size.width, 44.0f);
        CGPoint toolbarOrigin = CGPointMake(0, CGRectGetHeight(self.view.bounds) - (toolbarSize.height + self.navigationController.navigationBar.frame.size.height));
        CGRect toolbarFrame = CGRectMake(toolbarOrigin.x, toolbarOrigin.y, toolbarSize.width, toolbarSize.height);
        _toolBar = [[UIToolbar alloc] initWithFrame: toolbarFrame];
    }
    return _toolBar;
}

- (UIBarButtonItem *)backButton
{
    if (!_backButton) {
        _backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRewind
                                                                    target: self
                                                                    action: @selector(goBack)];
        _backButton.enabled = self.webView.canGoBack;
    }
    return _backButton;
}

- (UIBarButtonItem *)forwardButton
{
    if (!_forwardButton){
        _forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFastForward
                                                                       target: self
                                                                       action: @selector(goForward)];
        _forwardButton.enabled = self.webView.canGoForward;
    }
    return _forwardButton;
}

- (void)goBack
{
    [self.webView goBack];
}

- (void)goForward
{
    [self.webView goForward];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.backButton.enabled = webView.canGoBack;
    self.forwardButton.enabled = webView.canGoForward;
}


@end
