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
#import "ItemCell.h"

@interface ListViewController()
<NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSXMLParserDelegate>
{
    NSMutableData *xmlData;
    RSSChannel *channel;
}

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation ListViewController

- (void)fetchEntries
{
    xmlData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString: @"http://www.apple.com/pr/feeds/pr.rss"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL: url];
    
    self.connection = [[NSURLConnection alloc] initWithRequest: req
                                                      delegate: self
                                              startImmediately: YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle: style]) {
        [self fetchEntries];
    }
    return self;
}

- (void)viewDidLoad
{
    [self.tableView registerNib: [UINib nibWithNibName:@"ItemCell" bundle: nil]
         forCellReuseIdentifier: @"ItemCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = channel.items.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ItemCell"];
    
    RSSItem *item = channel.items[indexPath.row];
    
    cell.titleLabel.text = item.title;
    cell.linkLabel.text = item.link;
    cell.pubDateLabel.text = item.pubDate;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController: self.webViewController animated: YES];
    
    RSSItem *entry = channel.items[indexPath.row];
    
    NSURL *url = [NSURL URLWithString: entry.link];
    
    NSURLRequest *req = [NSURLRequest requestWithURL: url];
    
    [self.webViewController.webView  loadRequest: req];
    self.webViewController.navigationItem.title = entry.title;
    
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [xmlData appendData: data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.connection = nil;
    
    xmlData = nil;
    
    NSString *errorString = [NSString stringWithFormat: @"Fetch failed: %@", [error localizedDescription]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Error"
                                                        message: errorString
                                                       delegate: nil
                                              cancelButtonTitle: @"Ok"
                                              otherButtonTitles: nil];
    [alertView show];
}


#pragma mark - NSURLConnectionDataDelegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData: xmlData];
    
    [parser setDelegate: self];
    
    [parser parse];
    
    xmlData = nil;
    self.connection = nil;
    
    [self.tableView reloadData];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    NSLog(@"%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual:@"channel"]) {
        channel = [[RSSChannel alloc] init];
        channel.parentParserDelegate = self;
        parser.delegate = channel;
    }
    
}

- (WebViewController *)webViewController
{
    if (!_webViewController) {
        _webViewController = [[WebViewController alloc] init];
    }
    return _webViewController;
}

@end
