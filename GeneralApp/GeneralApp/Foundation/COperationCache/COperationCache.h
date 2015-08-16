//
//  COperationCache.h
//  GeneralApp
//
//  Created by hinkey on 15/8/16.
//  Copyright (c) 2015年 hinkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHTTPOperation.h"

@interface COperationCache : NSObject

// Default is 8
+ (void)setMaxConcurrentCount:(NSInteger)count;

// Add operation for cache
// The operation will be stored, so you have to remove by
// calling removeOperation method. Or, the object will never
// be dealloced.
+ (void)addOperation:(NSOperation *)operation;

// Remove the operation to release the memory
+ (void)removeOperation:(NSOperation *)operation;

// Return all specified type
+ (NSArray *)operationWith:(CHTTPType)type;

// Clear the memory
+ (void)clearMemory;

// Get size of caches
+ (size_t)sizeOfCaches;

// Clear all cached files
+ (void)clearAllCaches;

@end
