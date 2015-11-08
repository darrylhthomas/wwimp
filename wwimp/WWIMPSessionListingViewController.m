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
#import "WWIMPSession.h"

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


- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    _fetchedResultsController = fetchedResultsController;
    [self reloadTableViewIfNeeded];
}

- (void)reloadTableViewIfNeeded
{
    if (self.isViewLoaded) {
        NSError *error = nil;
        if ([self.fetchedResultsController performFetch:&error]) {
            [self.tableView reloadData];
        } else {
            NSLog(@"Error performing fetch: %@", [error localizedDescription]);
        }
    }
}

- (void)updateSessionDetailsWithIndexPath:(NSIndexPath *)indexPath
{
    [self.imageLoadingActivityIndicatorView stopAnimating];
    self.focusedIndexPath = indexPath;
    WWIMPSession *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.descriptionLabel.text = session.descriptionText;
    NSArray *focuses = [[session valueForKeyPath:@"focuses.name"] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
    self.focusLabel.text = [focuses componentsJoinedByString:@", "];
    self.yearLabel.text = [session.year stringValue];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ – %@", session.id, session.title];
    self.shelfImageView.image = nil;
    
    self.descriptionLabel.hidden = NO;
    self.focusLabel.hidden = NO;
    self.yearLabel.hidden = NO;
    self.titleLabel.hidden = NO;
    self.shelfImageView.hidden = NO;

    NSString *imageKey = [NSString stringWithFormat:@"%@-%@", [session.year stringValue], [session.id stringValue]];
    NSURL *imageSourceURL = [NSURL URLWithString:session.shelfImageURLString];
    if (imageSourceURL == nil) {
        self.shelfImageView.image = [UIImage imageNamed:@"MissingShelfImage"];
    } else {
        __weak WWIMPSessionListingViewController *weakSelf = self;
        [self.imageLoadingActivityIndicatorView startAnimating];
        [self.imageDataSource retrieveImageWithKey:imageKey sourceURL:imageSourceURL completionQueue:nil completionHandler:^(NSString * _Nonnull key, UIImage * _Nullable image, NSError * _Nullable error) {
            __strong WWIMPSessionListingViewController *strongSelf = weakSelf;
            if (strongSelf != nil && [strongSelf.focusedIndexPath isEqual:indexPath]) {
                WWIMPSession *session = [strongSelf.fetchedResultsController objectAtIndexPath:indexPath];
                NSString *currentImageKey = [NSString stringWithFormat:@"%@-%@", [session.year stringValue], [session.id stringValue]];
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
    WWIMPSession *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
    AVPlayerViewController *viewController = [segue destinationViewController];
    viewController.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:session.urlString]];
    [viewController.player play];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray<id<NSFetchedResultsSectionInfo>> *sections = self.fetchedResultsController.sections;
    if ([sections count] > 0) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWIMPSession *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionCell" forIndexPath:indexPath];
    cell.textLabel.text = session.title;
    cell.detailTextLabel.text = [session.id stringValue];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray<id<NSFetchedResultsSectionInfo>> *sections = self.fetchedResultsController.sections;
    if ([sections count] > 0) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        return [sectionInfo name];
    }
    
    return nil;
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
