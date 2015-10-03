//
//  CustomLabel.m
//  DynamicTableCell
//
//  Created by Tasvir H Rohila on 03/10/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    // If this is a multiline label, need to make sure
    // preferredMaxLayoutWidth always matches the frame width
    // (i.e. orientation change can mess this up)
    
    if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}

@end
