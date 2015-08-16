//
//  COperationCache.m
//  GeneralApp
//
//  Created by hinkey on 15/8/16.
//  Copyright (c) 2015年 hinkey. All rights reserved.
//

#import "COperationCache.h"
#import "Constants.h"
#import <UIKit/UIKit.h>

static COperationCache *sharedCache = nil;

@interface COperationCache()
{
    NSOperationQueue *_operationQueue;
    NSMutableArray *_operations;
}

+ (COperationCache *)sharedCache;

@end

@implementation COperationCache

#pragma mark - Singleton

+ (COperationCache *)sharedCache
{
    @synchronized (self)
    {
        if (sharedCache == nil) {
            sharedCache = [[self alloc] init];
        }
    }
    return sharedCache;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (sharedCache == nil) {
            sharedCache = [super allocWithZone:zone];
            return sharedCache;
        }
    }
    return nil;
}

- (id)init
{
    @synchronized(self) {
        self = [super init];
        if (self) {
            // Initialize
            _operations = [NSMutableArray array];
            _operationQueue = [[NSOperationQueue alloc]init];
            _operationQueue.maxConcurrentOperationCount = 8;
            
            // Received memory warning
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(appDidBReceiveMemoryWarning)
                                                        name:UIApplicationDidReceiveMemoryWarningNotification
                                                      object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(appDidEnterBackground)
                                                        name:UIApplicationDidEnterBackgroundNotification
                                                      object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(appDidBecomeActive)
                                                        name:UIApplicationDidBecomeActiveNotification
                                                      object:nil];
        }
        
        return self;
    }
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Methods

+ (void)setMaxConcurrentCount:(NSInteger)count
{
    [[self sharedCache]setMaxConcurrentCount:count];
}

// Add operation for cache
+ (void)addOperation:(NSOperation *)operation
{
    if (operation) {
        [[self sharedCache]addOperation:operation];
    }
}

+ (void)removeOperation:(NSOperation *)operation
{
    if (operation) {
        [[self sharedCache]removeOperation:operation];
    }
}

// Return all specified type
+ (NSArray *)operationWith:(CHTTPType)type
{
    return [[self sharedCache]operationWith:type];
}

// Clear the memory
+ (void)clearMemory
{
    [[self sharedCache]clearMemory];
}

// Get size of caches
+ (size_t)sizeOfCaches
{
    return 0;
}

// Clear all cached files
+ (void)clearAllCaches
{
    NSString *path = cacheDirectoryPath();
    
    NSLog(@"%@", path);
}

- (void)appDidBReceiveMemoryWarning
{
    [self clearMemory];
}

- (void)appDidEnterBackground
{
    _operationQueue.suspended = YES;
}

- (void)appDidBecomeActive
{
    _operationQueue.suspended = NO;
}

- (void)setMaxConcurrentCount:(NSInteger)count
{
    _operationQueue.maxConcurrentOperationCount = count;
}

- (void)addOperation:(NSOperation *)operation
{
    [_operations addObject:operation];
    [_operationQueue addOperation:operation];
}

- (void)removeOperation:(NSOperation *)operation
{
    [_operations removeObject:operation];
}

- (NSArray *)operationWith:(CHTTPType)type
{
    if (_operations.count > 0) {
        NSMutableArray *operations = [NSMutableArray array];
        for (CHTTPOperation *operation in _operations) {
            if (operation.type == type) {
                [operations addObject:operation];
            }
        }
        
        return (operations.count > 0)?operations:nil;
    }
    
    return nil;
}

- (void)clearMemory
{
    [_operations removeAllObjects];
    [_operationQueue cancelAllOperations];
}


@end
