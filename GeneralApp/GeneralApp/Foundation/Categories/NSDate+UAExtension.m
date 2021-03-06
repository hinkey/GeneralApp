#import "NSDate+UAExtension.h"

@implementation NSDate (UAExtension)

+ (NSInteger)timeInterval
{
    @autoreleasepool
    {
        NSDate *date = [NSDate date];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:timeZone];
        NSString *timestamp = [dateFormatter stringFromDate:date];
        
        return [[dateFormatter dateFromString:timestamp]timeIntervalSince1970];
    }
}

+ (NSDate *)dateWithFormat:(NSString *)format
{
    @autoreleasepool
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:format];
        NSDate *date = [NSDate date];
        
        return [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
    }
}

// Time gap day
- (NSInteger)numberOfDaysFromDate:(NSDate *)date
{
    NSTimeInterval now = [self timeIntervalSince1970];
    NSTimeInterval time = [date timeIntervalSince1970];
    
    return (NSInteger)floorf((time - now)/(3600*24.0));
}

// Time gap hours
- (NSInteger)numberOfHoursFromDate:(NSDate *)date
{
    NSTimeInterval now = [self timeIntervalSince1970];
    NSTimeInterval time = [date timeIntervalSince1970];
    
    return floorf((time - now)/3600.0);
}

// Time gap minute
- (NSInteger)numberOfMinutesFromDate:(NSDate *)date
{
    NSTimeInterval now = [self timeIntervalSince1970];
    NSTimeInterval time = [date timeIntervalSince1970];
    
    return floorf((time - now)/60.0);
}

// Time gap seconds
- (NSInteger)numberOfSecondsFromDate:(NSDate *)date
{
    NSTimeInterval now = [self timeIntervalSince1970];
    NSTimeInterval time = [date timeIntervalSince1970];
    
    return floorf(time - now);
}

- (NSString *)stringWithFormat:(NSString *)format
{
    @autoreleasepool
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:format];
        
        return [formatter stringFromDate:self];
    }
}

- (NSDate *)dateWithTimeInterval:(NSTimeInterval)time
{
    return [self dateByAddingTimeInterval:time];
}

+ (NSString *)currentWithFormat:(NSString *)format
{
    @autoreleasepool {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:format];
        NSDate *date = [NSDate date];
        
        return [dateFormatter stringFromDate:date];
    }
}

@end