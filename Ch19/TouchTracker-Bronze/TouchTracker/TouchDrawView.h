//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Brent Westmoreland on 8/27/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchDrawViewDataSource <NSObject>

- (NSArray *)completeLines;
- (NSDictionary *)linesInProcess;

@end

@interface TouchDrawView : UIView

@property (nonatomic, weak) id <TouchDrawViewDataSource> datasource;

@end
