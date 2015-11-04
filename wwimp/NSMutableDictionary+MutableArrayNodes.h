//
//  NSMutableDictionary+MutableArrayNodes.h
//  wwimp
//
//  Created by Darryl H. Thomas on 11/3/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (MutableArrayNodes)

- (void)addObject:(id _Nonnull)obj toArrayWithKey:(id<NSCopying> _Nonnull)key;

@end
