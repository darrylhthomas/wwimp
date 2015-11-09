//
//  WWIMPTrackOrderTableViewController.m
//  wwimp
//
//  Created by Darryl H. Thomas on 11/8/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import "WWIMPTrackOrderTableViewController.h"
#import "WWIMPTrack.h"

#define MAX_TAB_COUNT 7

@interface WWIMPTrackOrderTableViewController ()
@property (nonatomic, copy) NSArray *tabTracks;
@property (nonatomic, copy) NSArray *moreTracks;
@end

@implementation WWIMPTrackOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.editing = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTracks:(NSArray *)tracks
{
    _tracks = [tracks copy];
    [self setTabAndMoreTracksFromCombinedTracks];
    if (self.isViewLoaded) {
        [self.tableView reloadData];
    }
}

- (void)setTabAndMoreTracksFromCombinedTracks
{
    if ([_tracks count] > MAX_TAB_COUNT) {
        self.tabTracks = [_tracks subarrayWithRange:NSMakeRange(0, MAX_TAB_COUNT - 1)];
        self.moreTracks = [_tracks subarrayWithRange:NSMakeRange(MAX_TAB_COUNT - 1, [_tracks count] - (MAX_TAB_COUNT - 1))];
    } else {
        self.tabTracks = _tracks;
        self.moreTracks = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.moreTracks != nil) ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self.tabTracks count];
            break;
        case 1:
            return [self.moreTracks count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Visible Tabs", nil);
            break;
        case 1:
            return NSLocalizedString(@"More…", nil);
            break;
        default:
            return nil;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWIMPTrack *track = nil;
    switch (indexPath.section) {
        case 0:
            track = self.tabTracks[indexPath.row];
            break;
        case 1:
            track = self.moreTracks[indexPath.row];
        default:
            break;
    }
    if (track == nil) {
        return nil;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackCell" forIndexPath:indexPath];
    cell.textLabel.text = track.name;
    cell.showsReorderControl = YES;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *tabTracks = [self.tabTracks mutableCopy];
    NSMutableArray *moreTracks = [self.moreTracks mutableCopy];
    NSMutableArray *fromTracks = (fromIndexPath.section == 0) ? tabTracks : moreTracks;
    NSMutableArray *toTracks = (toIndexPath.section == 0) ? tabTracks : moreTracks;
    WWIMPTrack *movedTrack = [fromTracks objectAtIndex:fromIndexPath.row];
    [fromTracks removeObjectAtIndex:fromIndexPath.row];
    [toTracks insertObject:movedTrack atIndex:toIndexPath.row];
    NSArray *allTracks = [tabTracks arrayByAddingObjectsFromArray:moreTracks];
    self.tracks = allTracks;
    [self.delegate trackOrderTableViewController:self didReorderTracks:self.tracks];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
