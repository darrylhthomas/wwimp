//
//  WWIMPTrackOrderTableViewController.h
//  wwimp
//
//  Created by Darryl H. Thomas on 11/8/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWIMPTrack;
@protocol WWIMPTrackOrderTableViewControllerDelegate;

@interface WWIMPTrackOrderTableViewController : UITableViewController

@property (nonatomic, copy) NSArray *tracks;
@property (nonatomic, weak) IBOutlet id<WWIMPTrackOrderTableViewControllerDelegate> delegate;

@end

@protocol WWIMPTrackOrderTableViewControllerDelegate <NSObject>

- (void)trackOrderTableViewController:(WWIMPTrackOrderTableViewController *)controller didReorderTracks:(NSArray<WWIMPTrack*> *)tracks;

@end

