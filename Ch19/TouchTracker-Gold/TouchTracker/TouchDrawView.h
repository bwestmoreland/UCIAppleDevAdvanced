//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Brent Westmoreland on 8/27/13.
//  Copyright (c) 2013 Brent Westmoreland. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchDrawViewDataSource <NSObject>

- (NSMutableArray *)completeLines;
- (NSMutableDictionary *)linesInProcess;
- (NSMutableDictionary *)circlesInProcess;
- (NSMutableArray *)completeCircles;

@end

@interface TouchDrawView : UIView

@property (nonatomic, weak) id <TouchDrawViewDataSource> datasource;

@end
