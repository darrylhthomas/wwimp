//
//  WWIMPImageDataSource.h
//  wwimp
//
//  Created by Darryl H. Thomas on 11/3/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWIMPImageDataSource : NSObject

@property (nonatomic, readonly) NSURL* _Nullable persistentCacheURL;

- (instancetype _Nonnull)initWithPersistentCacheURL:(NSURL* _Nullable)persistentCacheURL NS_DESIGNATED_INITIALIZER;

- (void)retrieveImageWithKey:(NSString* _Nonnull)key sourceURL:(NSURL* _Nonnull)sourceURL completionQueue:(NSOperationQueue* _Nullable)completionQueue completionHandler:(void(^_Nonnull)(NSString* _Nonnull key, UIImage* _Nullable image, NSError* _Nullable error))completionBlock;

@end
