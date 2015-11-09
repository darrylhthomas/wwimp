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

#define MINIMUM_RESUMABLE_PLAYHEAD_POSITION 15
#define MINIMUM_RESUMABLE_SECONDS_REMAINING 60

@interface WWIMPSessionListingViewController ()
@property (nonatomic) NSIndexPath *focusedIndexPath;
@property (nonatomic) BOOL wantsRestart;
@end

@implementation WWIMPSessionListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.remembersLastFocusedIndexPath = YES;
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

    NSString *imageKey = session.key;
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
                NSString *currentImageKey = session.key;
                if ([currentImageKey isEqualToString:key]) {
                    strongSelf.shelfImageView.image = image;
                    [strongSelf.imageLoadingActivityIndicatorView stopAnimating];
                }
            }
        }];
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"PlaySession"]) {
        UITableViewCell *selectedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
        WWIMPSession *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSUInteger lastPlayPosition = [[NSUserDefaults standardUserDefaults] integerForKey:session.lastPlayPositionUserDefaultsKey];
        if (lastPlayPosition > 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Resume Playing", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.wantsRestart = NO;
                [self performSegueWithIdentifier:identifier sender:sender];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Start from Beginning", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.wantsRestart = YES;
                [self performSegueWithIdentifier:identifier sender:sender];
            }]];
            [self.navigationController.tabBarController presentViewController:alertController animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlaySession"]) {
        UITableViewCell *selectedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
        WWIMPSession *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
        AVPlayerViewController *viewController = [segue destinationViewController];
        viewController.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:session.urlString]];
        NSString *lastPlayPositionKey = session.lastPlayPositionUserDefaultsKey;
        __weak AVPlayerViewController *weakViewController = viewController;
        [viewController.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            __strong AVPlayerViewController *strongViewController = weakViewController;
            if (strongViewController) {
                NSUInteger lastPlayPosition = floorl(CMTimeGetSeconds(time));
                NSUInteger durationInSeconds = floorl(CMTimeGetSeconds(strongViewController.player.currentItem.duration));
                if (lastPlayPosition < MINIMUM_RESUMABLE_PLAYHEAD_POSITION || (durationInSeconds - lastPlayPosition) < MINIMUM_RESUMABLE_SECONDS_REMAINING) {
                    lastPlayPosition = 0;
                }
                [[NSUserDefaults standardUserDefaults] setInteger:lastPlayPosition forKey:lastPlayPositionKey];
            }
        }];
        
        NSUInteger lastPlayPosition = [[NSUserDefaults standardUserDefaults] integerForKey:lastPlayPositionKey];
        if (lastPlayPosition > 0 && !self.wantsRestart) {
            [viewController.player seekToTime:CMTimeMake(lastPlayPosition, 1)];
        }
        [viewController.player play];
    }
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
