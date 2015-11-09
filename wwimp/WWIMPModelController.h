//
//  WWIMPModelController.h
//  wwimp
//
//  Created by Darryl H. Thomas on 11/5/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WWIMPSession.h"
#import "WWIMPTrack.h"
#import "WWIMPFocus.h"

@interface WWIMPModelController : NSObject

@property (nonatomic) NSManagedObjectContext *mainQueueManagedObjectContext;

- (instancetype)initWithRemoteSessionsURL:(NSURL *)remoteSessionsURL documentURL:(NSURL *)localDocumentURL NS_DESIGNATED_INITIALIZER;

- (void)fetchTracksWithCompletionHandler:(void(^)(NSArray<WWIMPTrack*> *tracks, NSError *error))completionHandler;
- (void)reorderTracks:(NSArray<WWIMPTrack*> *)tracks withCompletionHandler:(void(^)(BOOL success, NSError *error))completionHandler;

@end
