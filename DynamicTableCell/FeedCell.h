//
//  FeedCell.h
//  DynamicTableCell
//
//  Created by Tasvir H Rohila on 03/10/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@interface FeedCell : UITableViewCell

@property (nonatomic, weak) IBOutlet CustomLabel *titleLabel;
@property (nonatomic, weak) IBOutlet CustomLabel *subtitleLabel;

@end
