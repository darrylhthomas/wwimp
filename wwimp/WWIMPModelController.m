//
//  WWIMPModelController.m
//  wwimp
//
//  Created by Darryl H. Thomas on 11/5/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

@import CoreData;
#import "WWIMPModelController.h"
#import "WWIMPSessionFinder.h"

@interface WWIMPModelController ()

@property (nonatomic) NSURL *remoteSessionsURL;
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (nonatomic) BOOL needsImport;
@property (nonatomic, copy, readonly) NSMutableArray *importCompletionBlocks;

@end

@implementation WWIMPModelController

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

- (instancetype)initWithRemoteSessionsURL:(NSURL *)remoteSessionsURL documentURL:(NSURL *)localDocumentURL
{
    self = [super init];
    if (self) {
        self.remoteSessionsURL = remoteSessionsURL;
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
                                      
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"wwimp" withExtension:@"momd"];
        self.needsImport = ![fileManager fileExistsAtPath:[localDocumentURL path]];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:localDocumentURL options:nil error:&error];
        if (!self.persistentStoreCoordinator) {
            NSLog(@"Error initializating persistent store coordinator: %@", [error localizedDescription]);
            return nil;
        }

        self.backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        self.backgroundManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        
        self.mainQueueManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        self.mainQueueManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;

        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:self.backgroundManagedObjectContext queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {
            [self.mainQueueManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        }];
        
    }
    
    return self;
}

- (void)performImportIfNeededFollowedByBlock:(void(^)(void))blockToExecute
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.needsImport) {
            if (self.importCompletionBlocks) {
                [self.importCompletionBlocks addObject:[blockToExecute copy]];
            } else {
                _importCompletionBlocks = [@[[blockToExecute copy]] mutableCopy];
                [self performImport];
            }
        } else {
            blockToExecute();
        }
    });
}

- (void)performImport
{
    WWIMPSessionFinder *sessionFinder = [[WWIMPSessionFinder alloc] init];
    [sessionFinder findSessionsWithURL:self.remoteSessionsURL completionQueue:nil completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSArray *tracks = sessionFinder.tracks;
        NSArray *sessions = sessionFinder.allSessions;
        NSManagedObjectContext *context = self.backgroundManagedObjectContext;
        [context performBlock:^{

            NSMutableDictionary *tracksByName = [[NSMutableDictionary alloc] initWithCapacity:[tracks count]];
            [tracks enumerateObjectsUsingBlock:^(NSString *trackName, NSUInteger idx, BOOL * _Nonnull stop) {
                WWIMPTrack *track = [WWIMPTrack insertInManagedObjectContext:context];
                track.name = trackName;
                track.order = @(idx);
                tracksByName[trackName] = track;
            }];
            
            NSMutableDictionary *focusesByName = [[NSMutableDictionary alloc] init];
            for (NSDictionary *sessionDictionary in sessions) {
                WWIMPSession *session = [WWIMPSession insertInManagedObjectContext:context];
                session.id = sessionDictionary[@"id"];
                session.descriptionText = sessionDictionary[@"description"];
                session.title = sessionDictionary[@"title"];
                session.shelfImageURLString = sessionDictionary[@"images"][@"shelf"];
                session.urlString = sessionDictionary[@"url"];
                session.year = sessionDictionary[@"year"];
                
                session.track = tracksByName[sessionDictionary[@"track"]];
                
                for (NSString *focusName in sessionDictionary[@"focus"]) {
                    WWIMPFocus *focus = focusesByName[focusName];
                    if (!focus) {
                        focus = [WWIMPFocus insertInManagedObjectContext:context];
                        focus.name = focusName;
                        focusesByName[focusName] = focus;
                    }
                    [session.focusesSet addObject:focus];
                }
            }
            
            NSError *saveError = nil;
            if ([context save:&saveError]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.needsImport = NO;
                    NSArray *completionBlocks = self.importCompletionBlocks;
                    _importCompletionBlocks = nil;
                    for (dispatch_block_t blockToExecute in completionBlocks) {
                        blockToExecute();
                    }
                });
            } else {
                NSLog(@"Error while saving MOC: %@", [saveError localizedDescription]);
            }
        }];
    }];
}

- (void)fetchTracksWithCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler
{
    [self performImportIfNeededFollowedByBlock:^{
        [self.backgroundManagedObjectContext performBlock:^{
            NSError *backgroundError = nil;
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[WWIMPTrack entityName]];
            request.resultType = NSManagedObjectIDResultType;
            NSArray *managedObjectIDs = [self.backgroundManagedObjectContext executeFetchRequest:request error:&backgroundError];
            if (managedObjectIDs) {
                [self.mainQueueManagedObjectContext performBlock:^{
                    NSError *mainQueueError = nil;
                    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[WWIMPTrack entityName]];
                    request.resultType = NSManagedObjectResultType;
                    request.predicate = [NSPredicate predicateWithFormat:@"self IN %@", managedObjectIDs];
                    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]];
                    NSArray *tracks = [self.mainQueueManagedObjectContext executeFetchRequest:request error:&mainQueueError];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(tracks, mainQueueError);
                    });
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(nil, backgroundError);
                });
            }
            
        }];
    }];
}

@end
