//
//  WWIMPImageDataSource.m
//  wwimp
//
//  Created by Darryl H. Thomas on 11/3/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import "WWIMPImageDataSource.h"
#import "NSMutableDictionary+MutableArrayNodes.h"

@interface WWIMPImageDataSourceCompletionInfo : NSObject

@property (nonatomic, readonly, copy) void(^completionBlock)(NSString*, UIImage*, NSError*);
@property (nonatomic, readonly) NSOperationQueue *completionQueue;

- (instancetype)initWithCompletionBlock:(void(^)(NSString*, UIImage*, NSError*))completionBlock queue:(NSOperationQueue *)completionQueue NS_DESIGNATED_INITIALIZER;

@end


@interface WWIMPImageDataSource ()<NSURLSessionDelegate>

@property (nonatomic, readonly) dispatch_queue_t _Nonnull cacheQueue;
@property (nonatomic, readonly) NSOperationQueue *downloadDelegateOperationQueue;
@property (nonatomic, readonly) NSCache *cache;
@property (nonatomic, readonly) NSURLSession *urlSession;
@property (nonatomic, readonly) NSMutableDictionary *pendingCompletions;

@end

@implementation WWIMPImageDataSource

- (instancetype)initWithPersistentCacheURL:(NSURL *)persistentCacheURL
{
    self = [super init];
    if (self) {
        NSString *queueLabel = [NSString stringWithFormat:@"%@_cache_queue_%p", NSStringFromClass([self class]), (void *)self];
        _cacheQueue = dispatch_queue_create([queueLabel cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
        _downloadDelegateOperationQueue = [[NSOperationQueue alloc] init];
        _downloadDelegateOperationQueue.maxConcurrentOperationCount = 1;
        _cache = [[NSCache alloc] init];
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:_downloadDelegateOperationQueue];
        _pendingCompletions = [[NSMutableDictionary alloc] init];
        _persistentCacheURL = persistentCacheURL ?: [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    }
    
    return self;
}

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

- (void)retrieveImageWithKey:(NSString *)key sourceURL:(NSURL *)sourceURL completionQueue:(NSOperationQueue *)completionQueue completionHandler:(void (^)(NSString * _Nonnull, UIImage * _Nullable, NSError * _Nullable))completionHandler
{
    if (completionQueue == nil) {
        completionQueue = [NSOperationQueue mainQueue];
    }
    UIImage *image = [self.cache objectForKey:key];
    if (image) {
        [completionQueue addOperationWithBlock:^{
            completionHandler(key, image, nil);
        }];
        
        return;
    }
    
    dispatch_async(self.cacheQueue, ^{
        WWIMPImageDataSourceCompletionInfo *completionInfo = [[WWIMPImageDataSourceCompletionInfo alloc] initWithCompletionBlock:completionHandler queue:completionQueue];
        BOOL isOnlyPendingCompletion = (self.pendingCompletions[key] == nil);
        [self.pendingCompletions addObject:completionInfo toArrayWithKey:key];
        if (isOnlyPendingCompletion) {
            NSString *fileExtension = [sourceURL pathExtension];
            NSString *fileName = [NSString stringWithFormat:@"%@.%@", key, fileExtension];
            NSString *filePath = [[self.persistentCacheURL URLByAppendingPathComponent:fileName isDirectory:NO] path];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
            if (image) {
                [self.cache setObject:image forKey:key];
                [self performCompletionsForKey:key image:image error:nil];
            } else {
                [self downloadImageWithURL:sourceURL key:key destination:filePath];
            }
        }
    });
}

- (void)downloadImageWithURL:(NSURL *)sourceURL key:(NSString *)key destination:(NSString *)destinationFilePath
{
    NSURLSessionDownloadTask *downloadTask = [self.urlSession downloadTaskWithURL:sourceURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = nil;
        if (location) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createDirectoryAtURL:[NSURL fileURLWithPath:[destinationFilePath stringByDeletingLastPathComponent] isDirectory:YES] withIntermediateDirectories:YES attributes:nil error:nil];
            BOOL copied = [fileManager copyItemAtURL:location toURL:[NSURL fileURLWithPath:destinationFilePath] error:&error];
            if (copied) {
                image = [[UIImage alloc] initWithContentsOfFile:destinationFilePath];
                if (image) {
                    [self.cache setObject:image forKey:key];
                } else {
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey : NSLocalizedString(@"Image file could not be read.", nil)
                                               };
                    error = [NSError errorWithDomain:@"WWIMPImageDataSourceErrorDomain" code:100 userInfo:userInfo];
                }
            } else {
                NSFileManager *manager = [NSFileManager defaultManager];
                NSURL *testURL = location;
                while ([[testURL path] length] > 1) {
                    BOOL isDirectory = NO;
                    BOOL exists = [manager fileExistsAtPath:[testURL path] isDirectory:&isDirectory];
                    NSLog(@"URL %@: Exists? %@, Is Directory? %@", testURL, @(exists), @(isDirectory));
                    testURL = [testURL URLByDeletingLastPathComponent];
                }
            }
        }
        dispatch_async(self.cacheQueue, ^{
            [self performCompletionsForKey:key image:image error:error];
        });
    }];
    [downloadTask resume];
}

- (void)performCompletionsForKey:(NSString *)key image:(UIImage *)image error:(NSError *)error
{
    NSArray *completions = [self.pendingCompletions[key] copy];
    self.pendingCompletions[key] = nil;
    
    for (WWIMPImageDataSourceCompletionInfo *completionInfo in completions) {
        [completionInfo.completionQueue addOperationWithBlock:^{
            completionInfo.completionBlock(key, image, error);
        }];
    }
}

@end

@implementation WWIMPImageDataSourceCompletionInfo

- (instancetype)initWithCompletionBlock:(void (^)(NSString *, UIImage *, NSError *))completionBlock queue:(NSOperationQueue *)completionQueue
{
    self = [super init];
    if (self) {
        _completionBlock = [completionBlock copy];
        _completionQueue = completionQueue;
    }
    
    return self;
}

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

@end
