#import "CTimerBooster.h"
#import <objc/message.h>
#import "CThreadPool.h"

#pragma mark - CTimerBoosterItem class

@interface CTimerBoosterItem : NSObject

@property (nonatomic, assign) NSTimeInterval excuteTime;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) id object;
@property (nonatomic, assign) BOOL repeat;

- (id)init;
- (BOOL)execute;

@end

@implementation CTimerBoosterItem

- (id)init
{
    self = [super init];
    if (self) {
        self.excuteTime = 0;
        self.target = nil;
        self.selector = nil;
        self.object = nil;
        self.repeat = NO;
    }
    
    return self;
}

- (BOOL)execute
{
    BOOL result = NO;
    if (self.target && self.selector && [self.target respondsToSelector:self.selector]) {
        // Execute item
        IMP imp = [self.target methodForSelector:self.selector];
        if (imp) {
            void (*execute)(id, SEL, id) = (void *)imp;
            execute(self.target, self.selector, self.object);
            result = YES;
        }
    }
    
    return result;
}

- (void)dealloc
{
    NSLog(@"CTimerBoosterItem dealloc.");
}

@end

#pragma mark - CTimerBooster class

static CTimerBooster *sharedManager = nil;

@interface CTimerBooster ()
{
    NSLock *_accessLock;
    NSDateFormatter *_formatter;
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *itemArray;

- (void)addTarget:(id)target sel:(SEL)selector object:(id)object time:(NSTimeInterval)time repeat:(BOOL)repeat;
- (void)remove:(id)target sel:(SEL)selector;
- (void)kill;

@end

@implementation CTimerBooster

+ (id)sharedManager
{
    @synchronized (self) {
        if (sharedManager == nil) {
            return [[self alloc] init];
        }
    }
    
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (sharedManager == nil) {
            return [super allocWithZone:zone];
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
            sharedManager = self;
            _accessLock = [[NSLock alloc]init];
            
            // Keep time interval same
            NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            _formatter = [[NSDateFormatter alloc]init];
            [_formatter setTimeZone:zone];
            [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        
        return self;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Properties

- (NSTimer *)timer
{
    if (_timer) {
        return _timer;
    }
    
    _itemArray = @[];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f // More slower, less cpu used
                                              target:self
                                            selector:@selector(timeCounter)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    
    return _timer;
}

#pragma mark - Self Methods

- (NSTimeInterval)timeInterval
{
    @autoreleasepool
    {
        NSDate *date = [NSDate date];
        NSString *timestamp = [_formatter stringFromDate:date];
        
        return [[_formatter dateFromString:timestamp]timeIntervalSince1970];
    }
}

- (void)timeCounter
{
    [_accessLock lock];
    NSArray *itemArray = [NSArray arrayWithArray:self.itemArray];
    [_accessLock unlock];
    
    if (itemArray && itemArray.count > 0) {
        for (int i = 0; i < itemArray.count; i ++) {
            CTimerBoosterItem *item = itemArray[i];
            NSTimeInterval timeInterval = [self timeInterval];
            if (item.excuteTime <= timeInterval) {
                item.excuteTime = timeInterval;
                [CThreadPool addTarget:self sel:@selector(executeWith:) object:item];
            }
        }
    }
    
    itemArray = nil;
}

- (void)executeWith:(CTimerBoosterItem *)item
{
    if (![item execute] || !item.repeat) {
        // Remove the item that no need to be executed
        [self remove:item.target sel:item.selector];
        item = nil;
    } else {
        NSTimeInterval now = [self timeInterval];
        if ((now - item.excuteTime) > item.timeInterval) {
            NSInteger count = ceilf((now - item.excuteTime)/item.timeInterval);
            item.excuteTime += count * item.timeInterval;
        } else {
            item.excuteTime += item.timeInterval;
        }
    }
}

- (BOOL)isExistTarget:(id)target sel:(SEL)selector
{
    BOOL isFind = NO;
    
    [_accessLock lock];
    
    NSMutableArray *itemArray = [[NSMutableArray alloc]initWithArray:self.itemArray];
    for (int i = 0; i < itemArray.count; i ++) {
        // Remove the item
        CTimerBoosterItem *item = itemArray[i];
        NSString *className = NSStringFromClass([target class]);
        NSString *_className = NSStringFromClass([item.target class]);
        
        NSString *selName = NSStringFromSelector(selector);
        NSString *_selName = NSStringFromSelector(item.selector);
        
        if (!item.target || ((item.target == target) &&
                             [className isEqualToString:_className] &&
                             (item.selector == selector) &&
                             [selName isEqualToString:_selName]))
        {
            isFind = YES;
            break;
        }
    }
    
    [_accessLock unlock];
    
    return isFind;
}

- (void)addTarget:(id)target
              sel:(SEL)selector
           object:(id)object
             time:(NSTimeInterval)time
           repeat:(BOOL)repeat
{
    @autoreleasepool
    {
        if (self.itemArray.count > 30) {
            NSLog(@"ATTENTION: You add more target.");
            
            return;
        }
        
        [_accessLock lock];
        
        // 控制精度
        NSString *value = [NSString stringWithFormat:@"%.2lf", time];
        time = [value floatValue];
        
        CTimerBoosterItem *item = [[CTimerBoosterItem alloc]init];
        item.target = target;
        item.selector = selector;
        item.object = object;
        item.timeInterval = time;
        item.excuteTime = [self timeInterval] + time;
        item.repeat = repeat;
        
        NSInteger count = self.itemArray.count;
        NSMutableArray *mArray = [[NSMutableArray alloc]initWithArray:self.itemArray];
        if (count == 0) {
            [mArray addObject:item];
        } else {
            for (int i = 0; i < count; i ++) {
                CTimerBoosterItem *titem = self.itemArray[i];
                if (item.timeInterval < titem.timeInterval) {
                    [mArray insertObject:item atIndex:i];
                    break;
                } else if ((i + 1) >= count) {
                    [mArray addObject:item];
                    break;
                }
            }
        }
        
        self.itemArray = mArray;
        
        [_accessLock unlock];
    }
}

// 移除一个接收目标
- (void)remove:(id)target sel:(SEL)selector
{
    @autoreleasepool
    {
        [_accessLock lock];
        
        NSMutableArray *itemArray = [[NSMutableArray alloc]initWithArray:self.itemArray];
        for (int i = 0; i < itemArray.count; i ++) {
            // Remove the item
            CTimerBoosterItem *item = itemArray[i];
            NSString *className = NSStringFromClass([target class]);
            NSString *_className = NSStringFromClass([item.target class]);
            
            NSString *selName = NSStringFromSelector(selector);
            NSString *_selName = NSStringFromSelector(item.selector);
            
            if (!item.target || ((item.target == target) &&
                                 [className isEqualToString:_className] &&
                                 (item.selector == selector) &&
                                 [selName isEqualToString:_selName]))
            {
                [itemArray removeObject:item];
                
                break;
            }
        }
        self.itemArray = itemArray;
        
        [_accessLock unlock];
    }
}

// 关闭
- (void)kill
{
    @autoreleasepool
    {
        [self.timer invalidate];
        self.timer = nil;
        self.itemArray = nil;
    }
}

// 开始频率Timer计时
+ (void)start
{
    [[self sharedManager]timer];
}

+ (BOOL)isExistTarget:(id)target sel:(SEL)selector
{
    return [[self sharedManager]isExistTarget:target sel:selector];
}

// 添加一个接收目标, 不重复执行
+ (void)addTarget:(id)target sel:(SEL)selector time:(NSTimeInterval)time
{
    [[self sharedManager]addTarget:target sel:selector object:nil time:time repeat:NO];
}

// 添加一个接收目标
+ (void)addTarget:(id)target sel:(SEL)selector time:(NSTimeInterval)time repeat:(BOOL)repeat
{
    [[self sharedManager]addTarget:target sel:selector object:nil time:time repeat:repeat];
}

// 添加一个带参接收目标, 不重复执行
+ (void)addTarget:(id)target sel:(SEL)selector object:(id)object time:(NSTimeInterval)time
{
    [[self sharedManager]addTarget:target sel:selector object:object time:time repeat:NO];
}

// 添加一个带参接收目标
+ (void)addTarget:(id)target
              sel:(SEL)selector
           object:(id)object
             time:(NSTimeInterval)time
           repeat:(BOOL)repeat
{
    [[self sharedManager]addTarget:target sel:selector object:object time:time repeat:repeat];
}

// 移除一个接收目标
+ (void)removeTarget:(id)target sel:(SEL)selector
{
    [[self sharedManager]remove:target sel:selector];
}

// 关闭发生器
+ (void)kill
{
    [self kill];
}

@end
