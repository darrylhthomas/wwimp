//
//  WWIMPSessionListingNavigationController.h
//  wwimp
//
//  Created by Darryl H. Thomas on 11/2/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWIMPSessionListingViewController.h"

@interface WWIMPSessionListingNavigationController : UINavigationController

@property (nonatomic, weak, readonly) WWIMPSessionListingViewController *listingViewController;

@end
