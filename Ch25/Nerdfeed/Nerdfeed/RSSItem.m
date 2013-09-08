//
//  RSSItem.m
//  Nerdfeed
//
//  Created by Brent Westmoreland on 9/8/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "RSSItem.h"

@interface RSSItem()
{
    NSMutableString *currentString;
}

@end

@implementation RSSItem

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    NSLog(@"\t\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual: @"title"]) {
        currentString = [NSMutableString string];
        self.title = currentString;
    }
    else if ([elementName isEqual: @"link"]){
        currentString = [NSMutableString string];
        self.link = currentString;
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
    if ([elementName isEqual: @"item"]) {
        parser.delegate = self.parentParserDelegate;
    }
}


@end
