//
//  ListViewController.m
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "ListViewController.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "WebViewController.h"
#import "FeedStore.h"

typedef enum {
    ListViewControllerRSSTypeBNR,
    ListViewControllerRSSTypeApple
} ListViewControllerRSSType;

@interface ListViewController()
{
    RSSChannel *channel;
    ListViewControllerRSSType rssType;
}

@end

@implementation ListViewController

- (void)fetchEntries
{
    void (^completionBlock)(RSSChannel *obj, NSError *err) = ^(RSSChannel *obj, NSError *error) {
        if (!error) {
            channel = obj;
            [self.tableView reloadData];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Error"
                                                                message: [error localizedDescription]
                                                               delegate: nil
                                                      cancelButtonTitle: @"OK"
                                                      otherButtonTitles: nil];
            [alertView show];
        }        
    };
    
    if (rssType == ListViewControllerRSSTypeBNR) {
        [[FeedStore sharedStore] fetchRSSFeedWithCompletion: completionBlock];
    }
    else if (rssType == ListViewControllerRSSTypeApple) {
        [[FeedStore sharedStore] fetchTopSongs: 10
                                withCompletion: completionBlock];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle: style]) {
        UISegmentedControl *rssTypeControl = [[UISegmentedControl alloc] initWithItems: @[@"BNR", @"Apple"]];
        [rssTypeControl setSelectedSegmentIndex: 0];
        [rssTypeControl setSegmentedControlStyle: UISegmentedControlStyleBar];
        [rssTypeControl addTarget: self
                           action: @selector(changeType:)
                 forControlEvents: UIControlEventValueChanged];
        
        self.navigationItem.titleView = rssTypeControl;
        
        [self fetchEntries];
    }
    return self;
}

- (void)changeType: (id)sender
{
    rssType = [sender selectedSegmentIndex];
    [self fetchEntries];
}

- (void)viewDidLoad
{
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"UITableViewCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = channel.items.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"UITableViewCell"];
    
    RSSItem *item = channel.items[indexPath.row];
    
    cell.textLabel.text = item.title;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Nil it out so that we don't get history items in places we don't expect.
    self.webViewController = nil;
    
    [self.navigationController pushViewController: self.webViewController animated: YES];
    
    RSSItem *entry = channel.items[indexPath.row];
    
    NSURL *url = [NSURL URLWithString: entry.link];
    
    NSURLRequest *req = [NSURLRequest requestWithURL: url];
    
    [self.webViewController.webView  loadRequest: req];
    self.webViewController.navigationItem.title = entry.title;
    
}

- (WebViewController *)webViewController
{
    if (!_webViewController) {
        _webViewController = [[WebViewController alloc] init];
    }
    return _webViewController;
}

@end
