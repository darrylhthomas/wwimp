//
//  WWIMPSessionListingViewController.h
//  wwimp
//
//  Created by Darryl H. Thomas on 11/2/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWIMPSessionSelectionViewController;
@class WWIMPSessionDetailViewController;
@class WWIMPSessionFinder;
@class WWIMPImageDataSource;

@interface WWIMPSessionListingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *sessions;
@property (nonatomic, strong) WWIMPImageDataSource *imageDataSource;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *shelfImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *yearLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *imageLoadingActivityIndicatorView;

@end
