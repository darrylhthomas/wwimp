//
//  WWIMPMoreTableViewController.h
//  wwimp
//
//  Created by Darryl H. Thomas on 11/4/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWIMPTrackOrderTableViewController.h"

@protocol WWIMPMoreTableViewControllerDelegate;

@interface WWIMPMoreTableViewController : UITableViewController<WWIMPTrackOrderTableViewControllerDelegate>

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, copy) NSArray *allTracks;
@property (nonatomic, weak) IBOutlet id<WWIMPMoreTableViewControllerDelegate> delegate;

@end

@protocol WWIMPMoreTableViewControllerDelegate <NSObject>

@optional

- (void)moreTableViewController:(WWIMPMoreTableViewController *)controller didReorderTracks:(NSArray<WWIMPTrack *> *)tracks;

@end
