//
//  WWIMPSessionListingViewController.m
//  wwimp
//
//  Created by Darryl H. Thomas on 11/2/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

@import AVKit;
#import "WWIMPSessionListingViewController.h"
#import "WWIMPImageDataSource.h"

@interface WWIMPSessionListingViewController ()
@property (nonatomic) NSIndexPath *focusedIndexPath;
@end

@implementation WWIMPSessionListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self reloadTableViewIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setSessions:(NSArray *)sessions
{
    _sessions = [sessions copy];
    [self reloadTableViewIfNeeded];
}

- (void)reloadTableViewIfNeeded
{
    if (self.isViewLoaded) {
        [self.tableView reloadData];
    }
}

- (void)updateSessionDetailsWithIndexPath:(NSIndexPath *)indexPath
{
    [self.imageLoadingActivityIndicatorView stopAnimating];
    self.focusedIndexPath = indexPath;
    NSDictionary *session = self.sessions[indexPath.row];
    self.descriptionLabel.text = session[@"description"];
    self.yearLabel.text = [session[@"year"] stringValue];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ – %@", session[@"id"], session[@"title"]];
    self.shelfImageView.image = nil;
    
    self.descriptionLabel.hidden = NO;
    self.yearLabel.hidden = NO;
    self.titleLabel.hidden = NO;
    self.shelfImageView.hidden = NO;

    NSString *imageKey = [NSString stringWithFormat:@"%@-%@", [session[@"year"] stringValue], [session[@"id"] stringValue]];
    NSURL *imageSourceURL = [NSURL URLWithString:session[@"images"][@"shelf"]];
    if (imageSourceURL == nil) {
        self.shelfImageView.image = [UIImage imageNamed:@"MissingShelfImage"];
    } else {
        __weak WWIMPSessionListingViewController *weakSelf = self;
        [self.imageLoadingActivityIndicatorView startAnimating];
        [self.imageDataSource retrieveImageWithKey:imageKey sourceURL:imageSourceURL completionQueue:nil completionHandler:^(NSString * _Nonnull key, UIImage * _Nullable image, NSError * _Nullable error) {
            __strong WWIMPSessionListingViewController *strongSelf = weakSelf;
            if (strongSelf != nil && [strongSelf.focusedIndexPath isEqual:indexPath]) {
                NSDictionary *session = strongSelf.sessions[indexPath.row];
                NSString *currentImageKey = [NSString stringWithFormat:@"%@-%@", [session[@"year"] stringValue], [session[@"id"] stringValue]];
                if ([currentImageKey isEqualToString:key]) {
                    strongSelf.shelfImageView.image = image;
                    [strongSelf.imageLoadingActivityIndicatorView stopAnimating];
                }
            }
        }];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *selectedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
    NSDictionary *session = self.sessions[indexPath.row];
    AVPlayerViewController *viewController = [segue destinationViewController];
    viewController.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:session[@"url"]]];
    [viewController.player play];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sessions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *session = self.sessions[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionCell" forIndexPath:indexPath];
    cell.textLabel.text = session[@"title"];
    cell.detailTextLabel.text = [session[@"id"] stringValue];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
    NSIndexPath *nextIndexPath = context.nextFocusedIndexPath;
    if (nextIndexPath) {
        [self updateSessionDetailsWithIndexPath:nextIndexPath];
    }
}

@end
