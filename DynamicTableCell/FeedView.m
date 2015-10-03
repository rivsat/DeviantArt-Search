//
//  FeedView.m
//  DynamicTableCell
//
//  Created by Tasvir H Rohila on 03/10/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "FeedView.h"
#import "FeedController.h"
#import "FeedCell.h"

@interface FeedView ()

@property (nonatomic, strong) FeedController* feedController;

@end

@implementation FeedView

#pragma mark - lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFeedController];
    [self setupActivityIndicator];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self deselectAllRows];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup methods
- (void) setupFeedController {
    _feedController = [[FeedController alloc] initWithRootViewController:self];
}


- (void) setupActivityIndicator {
    [_resultsTableView setHidden:YES];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.frame = CGRectMake(self.view.frame.origin.x,
                                          self.view.frame.origin.y,
                                          self.view.frame.size.width,
                                          self.view.frame.size.height);
    [self.view addSubview:_activityIndicator];
}

- (void)deselectAllRows {
    for (NSIndexPath *indexPath in [self.resultsTableView indexPathsForSelectedRows]) {
        [self.resultsTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark - TableView DataSources
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_feedController.feedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self feedCellAtIndexPath:indexPath];
}

- (FeedCell *)feedCellAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell = [self.resultsTableView dequeueReusableCellWithIdentifier:kFeedCellIdentifier forIndexPath:indexPath];
    [self configureFeedCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureFeedCell:(FeedCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self setTitleForCell:cell atIndexPath:indexPath];
    [self setSubtitleForCell:cell atIndexPath:indexPath];
}

- (void)setTitleForCell:(FeedCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSString *title = [_feedController getTitle:indexPath.row];
    [cell.titleLabel setText:title];
}

- (void)setSubtitleForCell:(FeedCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSString *subtitle = [_feedController getSubTitle:indexPath.row];
    
    // Some subtitles can be really long, so only display the
    // first 200 characters
    if (subtitle.length > 200) {
        subtitle = [NSString stringWithFormat:@"%@...", [subtitle substringToIndex:200]];
    }
    
    [cell.subtitleLabel setText:subtitle];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForFeedCellAtIndexPath:indexPath];
}

- (CGFloat)heightForFeedCellAtIndexPath:(NSIndexPath *)indexPath {
    static FeedCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.resultsTableView dequeueReusableCellWithIdentifier:kFeedCellIdentifier];
    });
    
    [self configureFeedCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    //This will make each CustomLabel update its preferredMaxLayoutWidth property.
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.resultsTableView.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}


#pragma mark - Refresh
// called when keyboard search button
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self refreshData:searchBar];
}

- (IBAction)refreshData:(id)sender {
    [self.searchBar resignFirstResponder];
    [_resultsTableView setHidden:NO];
    [_feedController parseForQuery:self.searchBar.text];
}

- (void)showProgress {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[MBProgressHUD HUDForView:self.view] setLabelText:@"Loading"];
    [_activityIndicator startAnimating];
}

- (void)hideProgress {
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [_activityIndicator stopAnimating];
    if ([_feedController.feedItems count] < 1) {
        //Show Alert
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Deviant Art Search"
                                                            message:@"No feeds found. Please try other keywords."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];

    }
}

- (void)reloadTableViewContent {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.resultsTableView reloadData];
        [self.resultsTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    });
}

@end
