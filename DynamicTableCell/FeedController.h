//
//  FeedController.h
//  DynamicTableCell
//
//  Created by Tasvir H Rohila on 03/10/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedView.h"

@interface FeedController : NSObject
@property (nonatomic, copy) NSArray *feedItems;

- (id) initWithRootViewController:(FeedView*)rootViewController;
- (void)parseForQuery:(NSString *)query;
- (NSString *) getTitle:(NSInteger) index;
- (NSString *) getSubTitle:(NSInteger) index;
@end
