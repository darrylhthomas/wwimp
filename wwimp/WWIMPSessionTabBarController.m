//
//  WWIMPSessionTabBarController.m
//  wwimp
//
//  Created by Darryl H. Thomas on 11/2/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import "WWIMPSessionTabBarController.h"
#import "WWIMPSessionFinder.h"
#import "WWIMPSessionListingNavigationController.h"
#import "WWIMPImageDataSource.h"
#import "WWIMPModelController.h"

#define SESSION_REQUEST_URL_STRING @""

@interface WWIMPSessionTabBarController ()

@property (nonatomic) WWIMPImageDataSource *imageDataSource;
@property (nonatomic) BOOL needsURLAlert;
@property (nonatomic) NSError *lastError;
@property (nonatomic) WWIMPModelController *modelController;
@property (nonatomic, copy) NSArray *tracks;
@property (nonatomic, readonly) NSMutableDictionary *sessionNavigationControllersByTrackName;

@end

@implementation WWIMPSessionTabBarController
@synthesize sessionNavigationControllersByTrackName=_sessionNavigationControllersByTrackName;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // TODO: move all this elsewhere
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *storeURL = [[[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject] URLByAppendingPathComponent:@"wwimp.db"];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionsURLString = [defaults stringForKey:@"WWIMPSessionsURL"];
    if (!sessionsURLString) {
        sessionsURLString = SESSION_REQUEST_URL_STRING;
    }
    if ([sessionsURLString length] == 0) {
        self.needsURLAlert = YES;
        return;
    } else {
        [defaults setObject:sessionsURLString forKey:@"WWIMPSessionsURL"];
    }
    
    NSURL *sessionsURL = [NSURL URLWithString:sessionsURLString];
    
    self.modelController = [[WWIMPModelController alloc] initWithRemoteSessionsURL:sessionsURL documentURL:storeURL];
    NSURL *cachesURL = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    self.imageDataSource = [[WWIMPImageDataSource alloc] initWithPersistentCacheURL:[cachesURL URLByAppendingPathComponent:@"images" isDirectory:YES]];
    
    [self reloadTabs];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.needsURLAlert) {
        UIAlertController *alertController = [[UIAlertController alloc] init];
        alertController.title = NSLocalizedString(@"Sessions URL Required", nil);
        alertController.message = NSLocalizedString(@"Before you can use wwimp, you need to provide a session info URL. To do this, replace the empty string definition of \"SESSION_REQUEST_URL_STRING\" in WWIMPSessionTabBarController.m with an appropriate URL as specified in the README.md.", nil);
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Quit", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            exit(0);
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        self.needsURLAlert = NO;
    } else if (self.lastError) {
        [self presentAlertForError:self.lastError];
        self.lastError = nil;
    }

}

- (void)reloadTabs
{
    __weak WWIMPSessionTabBarController *weakSelf = self;
    [self.modelController fetchTracksWithCompletionHandler:^(NSArray<WWIMPTrack*> *tracks, NSError *error) {
        __strong WWIMPSessionTabBarController *strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if (tracks) {
            [strongSelf updateTabsWithTracks:tracks];
        } else {
            strongSelf.tracks = nil;
            strongSelf.viewControllers = nil;
            if (strongSelf.view.window) {
                [strongSelf presentAlertForError:error];
            } else {
                strongSelf.lastError = error;
            }
        }
    }];
}

- (void)updateTabsWithTracks:(NSArray<WWIMPTrack*> *)tracks
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:[tracks count]];
    for (WWIMPTrack *track in tracks) {
        WWIMPSessionListingNavigationController *navController = [self sessionNavigationControllerForTrack:track];
        [viewControllers addObject:navController];
    }
    
    if ([viewControllers count] > 7) {
        NSRange moreRange = NSMakeRange(6, [viewControllers count] - 6);
        NSArray *moreViewControllers = [viewControllers subarrayWithRange:moreRange];
        // TODO: refactor this for reuse
        WWIMPMoreTableViewController *moreViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreTableViewController"];
        moreViewController.viewControllers = moreViewControllers;
        moreViewController.allTracks = tracks;
        moreViewController.delegate = self;
        UINavigationController *moreNavigationController = [[UINavigationController alloc] initWithRootViewController:moreViewController];
        [viewControllers removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:moreRange]];
        [viewControllers addObject:moreNavigationController];
    }
    
    self.tracks = tracks;
    self.viewControllers = viewControllers;
}

- (NSMutableDictionary *)sessionNavigationControllersByTrackName
{
    if (!_sessionNavigationControllersByTrackName) {
        _sessionNavigationControllersByTrackName = [[NSMutableDictionary alloc] init];
    }
    
    return _sessionNavigationControllersByTrackName;
}

- (WWIMPSessionListingNavigationController *)sessionNavigationControllerForTrack:(WWIMPTrack *)track
{
    WWIMPSessionListingNavigationController *navController = self.sessionNavigationControllersByTrackName[track.name];
    if (navController == nil) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:track.name image:nil selectedImage:nil];
        
        navController = [self.storyboard instantiateViewControllerWithIdentifier:@"SessionListingNavigationController"];
        navController.tabBarItem = item;
        navController.listingViewController.title = track.name;
        navController.listingViewController.imageDataSource = self.imageDataSource;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"track = %@", track];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[WWIMPSession entityName]];
        fetchRequest.predicate = predicate;
        fetchRequest.sortDescriptors = @[
                                         [NSSortDescriptor sortDescriptorWithKey:@"year" ascending:NO],
                                         [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES],
                                         ];
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.modelController.mainQueueManagedObjectContext sectionNameKeyPath:@"year" cacheName:nil];
        navController.listingViewController.fetchedResultsController = fetchedResultsController;
        navController.listingViewController.modelController = self.modelController;
        self.sessionNavigationControllersByTrackName[track.name] = navController;
    }
    
    return navController;
}

- (void)presentAlertForError:(NSError *)error
{
    NSString *title = NSLocalizedString(@"Error Loading Sessions", nil);
    NSString *message = [error localizedDescription];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Retry", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reloadTabs];
    }];
    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Quit", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    [alertController addAction:retryAction];
    [alertController addAction:quitAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WWIMPMoreTableViewControllerDelegate

- (void)moreTableViewController:(WWIMPMoreTableViewController *)controller didReorderTracks:(NSArray<WWIMPTrack *> *)tracks
{
    [self.modelController reorderTracks:tracks withCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            [self updateTabsWithTracks:tracks];
        } else {
            NSString *title = NSLocalizedString(@"Error Reordering Tracks", nil);
            NSString *message = [error localizedDescription];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];    
}

@end
