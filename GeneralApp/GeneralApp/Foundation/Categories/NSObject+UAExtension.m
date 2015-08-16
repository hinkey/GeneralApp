#import "NSObject+UAExtension.h"
#import "CTimerBooster.h"

@implementation NSObject (UAExtension)

- (void)runOnMainThread:(SEL)sel
{
    [self runOnMainThread:sel withObject:nil];
}

- (void)runOnMainThread:(SEL)sel withObject:(id)object
{
    [self runOnMainThread:sel withObject:object waitUntilDone:NO];
}

- (void)runOnMainThread:(SEL)sel withObject:(id)object waitUntilDone:(BOOL)wait
{
    [self performSelectorOnMainThread:sel withObject:object waitUntilDone:wait];
}

- (void)runWithSelector:(SEL)sel afterDelay:(NSTimeInterval)time
{
    [self runWithSelector:sel withObject:nil afterDelay:time repeat:NO];
}

- (void)runWithSelector:(SEL)sel afterDelay:(NSTimeInterval)time repeat:(BOOL)repeat
{
    [self runWithSelector:sel withObject:nil afterDelay:time repeat:repeat];
}

- (void)runWithSelector:(SEL)sel withObject:(id)object afterDelay:(NSTimeInterval)time
{
    [self runWithSelector:sel withObject:object afterDelay:time repeat:NO];
}

- (void)runWithSelector:(SEL)sel withObject:(id)object afterDelay:(NSTimeInterval)time repeat:(BOOL)repeat
{
    [CTimerBooster start];
    [CTimerBooster addTarget:self sel:sel object:object time:time repeat:repeat];
}

@end
