//
//  WWIMPMoreTableViewController.m
//  wwimp
//
//  Created by Darryl H. Thomas on 11/4/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import "WWIMPMoreTableViewController.h"

@interface WWIMPMoreTableViewController ()

@end

@implementation WWIMPMoreTableViewController

- (void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = [viewControllers copy];
    if (self.isViewLoaded) {
        [self.tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OrderTracks"]) {
        WWIMPTrackOrderTableViewController *viewController = segue.destinationViewController;
        viewController.tracks = self.allTracks;
        viewController.delegate = self;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewControllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = self.viewControllers[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCell" forIndexPath:indexPath];
    cell.textLabel.text = viewController.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = self.viewControllers[indexPath.row];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - WWIMPTrackOrderTableViewControllerDelegate

-(void)trackOrderTableViewController:(WWIMPTrackOrderTableViewController *)controller didReorderTracks:(NSArray<WWIMPTrack *> *)tracks
{
    if ([self.delegate respondsToSelector:@selector(moreTableViewController:didReorderTracks:)]) {
        [self.delegate moreTableViewController:self didReorderTracks:tracks];
    }
}

@end
