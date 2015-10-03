//
//  FeedView.h
//  DynamicTableCell
//
//  Created by Tasvir H Rohila on 03/10/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@class RSSParser;

@interface FeedView : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (retain, nonatomic) UIActivityIndicatorView *activityIndicator;

- (IBAction)refreshData:(id)sender;
- (void)showProgress;
- (void)hideProgress;
- (void)reloadTableViewContent;
@end

