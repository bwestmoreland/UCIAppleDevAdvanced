//
//  ItemCell.m
//  Homepwner
//
//  Created by Brent Westmoreland on 6/20/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell


//This tableview needs to be synthesized like this
//to avoid conflicts with the _tableView backing store.
@synthesize tableView;

- (IBAction)showImage:(UIButton *)sender
{
    NSString *selector = NSStringFromSelector(_cmd);
    
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [tableView indexPathForCell: self];
    
    if (indexPath && [self.controller respondsToSelector: newSelector]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.controller performSelector: newSelector
                              withObject: sender
                              withObject: indexPath];
#pragma clang diagnostic pop
        
    }
}
@end
