//
//  WWIMPSessionFinder.h
//  wwimp
//
//  Created by Darryl H. Thomas on 11/2/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWIMPSessionFinder : NSObject

@property (nonatomic, readonly, copy) NSArray* _Nullable tracks;
@property (nonatomic, readonly, copy) NSArray* _Nullable allSessions;

- (void)findSessionsWithURL:(NSURL *_Nonnull)sessionsURL completionQueue:(NSOperationQueue* _Nullable)queue completionHandler:(void(^_Nullable)(BOOL success, NSError* _Nullable error))completionHandler;

@end
