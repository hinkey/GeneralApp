#import "CThreadPool.h"

static CThreadPool *sharedPool = nil;

@interface CThreadPool ()
{
    dispatch_queue_t _concurrentQueue;
    dispatch_queue_t _serialQueue;
    BOOL _concurrent;
}

@end

@implementation CThreadPool

#pragma mark - Singleton

+ (id)sharedPool
{
    @synchronized (self)
    {
        if (sharedPool == nil) {
            return [[self alloc] init];
        }
    }
    
    return sharedPool;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (sharedPool == nil) {
            return [super allocWithZone:zone];
        }
    }
    
    return nil;
}

- (id)init
{
    @synchronized(self) {
        self = [super init];
        // Initialize
        sharedPool = self;
        
        // Default no concurrent
        [self setConcurrent:NO];
        
        return self;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Methods

+ (void)setConcurrent:(BOOL)concurrent
{
    [[self sharedPool]setConcurrent:concurrent];
}

// Add a selector without object
+ (void)addTarget:(id)target sel:(SEL)selector
{
    [self addTarget:target sel:selector object:nil];
}

// Add a selector with object
+ (void)addTarget:(id)target sel:(SEL)selector object:(id)object
{
    [[self sharedPool]addTarget:target sel:selector object:object];
}

+ (void)addTarget:(id)target sels:(NSArray *)selectors
{
    [[self sharedPool]addTarget:target sels:selectors];
}

- (void)setConcurrent:(BOOL)concurrent
{
    _concurrent = concurrent;
    
    if (concurrent) {
        _concurrentQueue = dispatch_queue_create("CThreadPoolCQueue", DISPATCH_QUEUE_CONCURRENT);
        
        if (_serialQueue) {
            dispatch_release(_serialQueue);
            _serialQueue = NULL;
        }
    } else {
        _serialQueue = dispatch_queue_create("CThreadPoolSQueue", DISPATCH_QUEUE_SERIAL);
        
        if (_concurrentQueue) {
            dispatch_release(_concurrentQueue);
            _concurrentQueue = NULL;
        }
    }
}

- (void)addTarget:(id)target sel:(SEL)selector object:(id)object
{
    @autoreleasepool
    {
        if (_concurrentQueue) {
            dispatch_async(_concurrentQueue, ^{
                [self executeWith:target sel:selector object:object];
            });
        } else if (_serialQueue) {
            dispatch_async(_serialQueue, ^{
                [self executeWith:target sel:selector object:object];
            });
        }
    }
}

- (void)addTarget:(id)target sels:(NSArray *)selectors
{
    @autoreleasepool
    {
        for (NSString *selName in selectors) {
            SEL selector = NSSelectorFromString(selName);
            
            if (!_concurrent) {
                dispatch_async(_serialQueue, ^{
                    [self executeWith:target sel:selector object:nil];
                });
            } else {
                dispatch_async(_concurrentQueue, ^{
                    [self executeWith:target sel:selector object:nil];
                });
            }
        }
    }
}

- (void)executeWith:(id)target sel:(SEL)selector object:(id)object
{
    @autoreleasepool
    {
        if (target && [target respondsToSelector:selector]) {
            // Execute item
            IMP imp = [target methodForSelector:selector];
            void (*execute)(id, SEL, id) = (void *)imp;
            execute(target, selector, object);
        }
    }
}

@end
