//
//  FeedController.m
//  DynamicTableCell
//
//  Created by Tasvir H Rohila on 03/10/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "FeedController.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import <MediaRSSParser/MediaRSSParser.h>

@interface FeedController()
@property (weak, nonatomic) FeedView *rootViewController;
@property (nonatomic, strong) RSSParser *parser;

@end

@implementation FeedController

- (id) initWithRootViewController:(FeedView*)rootViewController {
    
    self = [FeedController new];
    
    if (self) {
        
        _rootViewController = rootViewController;
        /*
        _dataModel = [MVVM_model new];
        
        [_rootViewController setViewManager:self];
        
        [self setup_kRootViewController:rootViewController];
        */
        [self setUpParser];

    }
    
    return self;
}

- (void)setUpParser {
    self.parser = [[RSSParser alloc] init];
}

- (void)parseForQuery:(NSString *)query {
    [_rootViewController showProgress];
    
    __weak typeof(self) weakSelf = self;
    
    [self.parser parseRSSFeed:kDeviantArtBaseURLString
                   parameters:[self constructQueryParameters:query]
                      success:^(RSSChannel *channel) {
                          
                          [weakSelf convertItemsPropertiesToPlainText:channel.items];
                          [weakSelf setFeedItems:channel.items];
                          
                          [_rootViewController reloadTableViewContent];
                          [_rootViewController hideProgress];
                          
                      } failure:^(NSError *error) {
                          
                          [_rootViewController hideProgress];
                          NSLog(@"Error: %@", error);
                      }];
}


- (void)convertItemsPropertiesToPlainText:(NSArray *)items {
    for (RSSItem *item in items) {
        NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        item.title = [[item.title stringByConvertingHTMLToPlainText] stringByTrimmingCharactersInSet:charSet];
        item.mediaDescription = [[item.mediaDescription stringByConvertingHTMLToPlainText] stringByTrimmingCharactersInSet:charSet];
        item.mediaText = [[item.mediaText stringByConvertingHTMLToPlainText] stringByTrimmingCharactersInSet:charSet];
    }
}

- (NSDictionary *)constructQueryParameters:(NSString *)query {
    if (query.length) {
        return @{@"q": [NSString stringWithFormat:@"by:%@", query]};
        
    } else {
        return @{@"q": @"boost:popular"};
    }
}

- (NSString *) getTitle:(NSInteger) index {
    RSSItem *item = self.feedItems[index];
    NSString *title = item.title ?: NSLocalizedString(@"[No Title]", nil);
    return title;
}

- (NSString *) getSubTitle:(NSInteger) index {
    RSSItem *item = self.feedItems[index];
    NSString *subtitle = item.mediaText ?: item.mediaDescription;
    
    return subtitle;
}

@end
