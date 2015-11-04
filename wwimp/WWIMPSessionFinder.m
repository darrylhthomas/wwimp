//
//  WWIMPSessionFinder.m
//  wwimp
//
//  Created by Darryl H. Thomas on 11/2/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import "WWIMPSessionFinder.h"
#import "NSMutableDictionary+MutableArrayNodes.h"

@implementation WWIMPSessionFinder

- (void)findSessionsWithURL:(NSURL *_Nonnull)sessionsURL completionQueue:(NSOperationQueue* _Nullable)queue completionHandler:(void(^_Nullable)(BOOL success, NSError* _Nullable error))completionHandler
{
    if (queue == nil) {
        queue = [NSOperationQueue mainQueue];
    }
    
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:sessionsURL completionHandler:^(NSData * _Nullable responseData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!responseData) {
            if (completionHandler) {
                [queue addOperationWithBlock:^{
                    completionHandler(NO, error);
                }];
            }
            return;
        }
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
        NSArray *sessions = [responseDictionary valueForKeyPath:@"sessions"];
        
        /*
        // Only include sessions from 2015 for now
        sessions = [sessions objectsAtIndexes:[sessions indexesOfObjectsPassingTest:^BOOL(NSDictionary*  _Nonnull session, NSUInteger idx, BOOL * _Nonnull stop) {
            return [session[@"year"] isEqualToNumber:@2015];
        }]];
         */
        
        // Sessions are ordered in reverse chronological order, followed by ascending session id
        sessions = [sessions sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(NSDictionary*  _Nonnull session1, NSDictionary*  _Nonnull session2) {
            NSInteger year1 = [session1[@"year"] integerValue];
            NSInteger year2 = [session2[@"year"] integerValue];
            if (year1 < year2) {
                return NSOrderedDescending;
            } else if (year1 > year2) {
                return NSOrderedAscending;
            } else if ([session1[@"id"] integerValue] > [session2[@"id"] integerValue]) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        
        _tracks = [responseDictionary[@"tracks"] copy];
        _allSessions = [sessions copy];
        NSMutableDictionary *sessionsByTrack = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *sessionsByFocus = [[NSMutableDictionary alloc] init];
        for (NSDictionary *session in sessions) {
            NSString *track = session[@"track"];
            NSArray *foci = session[@"focus"];
            [sessionsByTrack addObject:session toArrayWithKey:track];
            for (NSString *focus in foci) {
                [sessionsByFocus addObject:session toArrayWithKey:focus];
            }
        }
        
        // Leaving the leaves mutable for now, because YOLO. This will likely all be persisted with Core Data eventually
        _sessionsByTrack = [sessionsByTrack copy];
        _sessionsByFocus = [sessionsByFocus copy];
        
        if (completionHandler) {
            [queue addOperationWithBlock:^{
                completionHandler(YES, nil);
            }];
        }
    }];
    [dataTask resume];
}

@end
