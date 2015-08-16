#import "CHTTPRequest.h"
#import "NSDictionary+UAExtension.h"
#import "COperationCache.h"

@interface CHTTPRequest ()

@end

static CHTTPRequest *sharedManager = nil;

@implementation CHTTPRequest

#pragma mark - Singleton

+ (CHTTPRequest *)sharedManager
{
    @synchronized (self)
    {
        if (sharedManager == nil) {
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (sharedManager == nil) {
            sharedManager = [super allocWithZone:zone];
            return sharedManager;
        }
    }
    return nil;
}

- (id)init
{
    @synchronized(self) {
        self = [super init];
        return self;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Request

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
            callback:(CHTTPCallback)callback
{
    [[self sharedManager] requestWithMethod:verb
                                        url:url
                                      param:param
                                    timeout:15
                                      retry:0
                               timeInterval:0
                                   callback:callback];
}

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
            callback:(CHTTPCallback)callback
{
    [[self sharedManager] requestWithMethod:verb
                                        url:url
                                      param:param
                                    timeout:timeout
                                      retry:0
                               timeInterval:0
                                   callback:callback];
}

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
            callback:(CHTTPCallback)callback
{
    [[self sharedManager] requestWithMethod:verb
                                        url:url
                                      param:param
                                    timeout:timeout
                                      retry:times
                               timeInterval:timeInterval
                                   callback:callback];
}

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<CHTTPRequestDelegate>)delegate
                 tag:(int)tag
{
    [[self sharedManager] requestWithMethod:verb
                                        url:url
                                      param:param
                                    timeout:15
                                      retry:0
                               timeInterval:0
                                   delegate:delegate
                                        tag:tag];
}

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<CHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
                 tag:(int)tag
{
    [[self sharedManager] requestWithMethod:verb
                                        url:url
                                      param:param
                                    timeout:timeout
                                      retry:0
                               timeInterval:0
                                   delegate:delegate
                                        tag:tag];
}

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<CHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
                 tag:(int)tag
{
    [[self sharedManager] requestWithMethod:verb
                                        url:url
                                      param:param
                                    timeout:timeout
                                      retry:times
                               timeInterval:timeInterval
                                   delegate:delegate
                                        tag:tag];
}

+ (NSData *)sendSynWith:(NSString *)method
                    url:(NSString *)url
                  param:(NSDictionary *)param
               response:(NSURLResponse **)response
                  error:(NSError **)error
{
    NSString *verb = [method uppercaseString];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    mutableRequest.HTTPMethod = verb;
    
    // Set content-type to support more data type
    NSString *contentType = @"application/json";
    [mutableRequest setValue:contentType forHTTPHeaderField:@"Content-type"];
    
    NSString *body = nil;
    if ([param isKindOfClass:[NSDictionary class]]) {
        @try {
            NSData *json = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
            body = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            mutableRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
        }
        @catch (NSException *exception) {
            NSLog(@"CHTTPRequest Exception:\n%@",exception);
            body = nil;
        }
    }
    
    return [NSURLConnection sendSynchronousRequest:mutableRequest returningResponse:response error:error];
}

- (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  timeout:(NSInteger)timeout
                    retry:(NSUInteger)times
             timeInterval:(NSInteger)timeInterval
                 callback:(CHTTPCallback)callback
{
    NSString *verb = [method uppercaseString];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    mutableRequest.HTTPMethod = verb;
    
    // Set content-type to support more data type
    NSString *contentType = @"application/json";
    [mutableRequest setValue:contentType forHTTPHeaderField:@"Content-type"];
    
    NSString *body = nil;
    if ([param isKindOfClass:[NSDictionary class]]) {
        @try {
            NSData *json = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
            body = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            mutableRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
        }
        @catch (NSException *exception) {
            NSLog(@"CHTTPRequest Exception:\n%@",exception);
            body = nil;
        }
    }
    
    // Add to operation queue
    CHTTPOperation *operation = [[CHTTPOperation alloc]initWithRequest:mutableRequest callback:callback];
    [operation setType:CHTTPTypeDefault];
    [operation setTimeout:timeout];
    [operation setRetryTimes:times];
    [operation setRetryTimeInterval:timeInterval];
    
    // Add to COperationCache
    [COperationCache addOperation:operation];
}

- (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  timeout:(NSInteger)timeout
                    retry:(NSUInteger)times
             timeInterval:(NSInteger)timeInterval
                 delegate:(id<CHTTPRequestDelegate>)delegate
                      tag:(int)tag
{
    NSString *verb = [method uppercaseString];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    mutableRequest.HTTPMethod = verb;
    
    // Set content-type to support more data type
    NSString *contentType = @"application/json";
    [mutableRequest setValue:contentType forHTTPHeaderField:@"Content-type"];
    
    NSString *body = nil;
    if ([param isKindOfClass:[NSDictionary class]]) {
        @try {
            NSData *json = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
            body = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            mutableRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
        }
        @catch (NSException *exception) {
            NSLog(@"CHTTPRequest Exception:\n%@",exception);
            body = nil;
        }
    }
    
    // Add to operation queue
    CHTTPOperation *operation = [[CHTTPOperation alloc]initWithRequest:mutableRequest
                                                              delegate:delegate
                                                                   tag:tag];
    [operation setType:CHTTPTypeDefault];
    [operation setTimeout:15];
    [operation setRetryTimes:times];
    [operation setRetryTimeInterval:timeInterval];
    
    // Add to COperationCache
    [COperationCache addOperation:operation];
}

@end
