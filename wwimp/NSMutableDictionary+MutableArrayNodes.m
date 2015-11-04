//
//  NSMutableDictionary+MutableArrayNodes.m
//  wwimp
//
//  Created by Darryl H. Thomas on 11/3/15.
//  Copyright © 2015 Darryl H. Thomas. All rights reserved.
//

#import "NSMutableDictionary+MutableArrayNodes.h"

@implementation NSMutableDictionary (MutableArrayNodes)

- (void)addObject:(id)obj toArrayWithKey:(id<NSCopying>)key
{
    id container = self[key];
    if (!container) {
        container = [[NSMutableArray alloc] init];
        self[key] = container;
    } else {
        NSParameterAssert([container isKindOfClass:[NSMutableArray class]]);
    }
    
    [container addObject:obj];
}

@end
