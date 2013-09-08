//
//  RSSChannel.m
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSItem.h"

@interface RSSChannel()
{
    NSMutableString *currentString;
}

@end

@implementation RSSChannel

- (id)init
{
    if (self = [super init]) {
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    NSLog(@"\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual: @"title"]) {
        currentString = [[NSMutableString alloc] init];
        self.title = currentString;
    }
    else if ([elementName isEqual: @"description"]){
        currentString = [[NSMutableString alloc] init];
        self.infoString = currentString;
    }
    else if ([elementName isEqual: @"item"]){
        RSSItem *entry = [[RSSItem alloc] init];
        
        entry.parentParserDelegate = self;
        parser.delegate = entry;
        
        [self.items addObject: entry];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentString appendString: string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    currentString = nil;
    if ([elementName isEqual: @"channel"]) {
        [parser setDelegate: self.parentParserDelegate];
    }
}

@end
