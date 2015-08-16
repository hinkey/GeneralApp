#import <Foundation/Foundation.h>
#import "CHTTPOperation.h"

@interface CHTTPRequest : NSObject

// Asynchronous request
// Block style
+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
            callback:(CHTTPCallback)callback;

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
            callback:(CHTTPCallback)callback;

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
            callback:(CHTTPCallback)callback;

// Delegate style
+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<CHTTPRequestDelegate>)delegate
                 tag:(int)tag;

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<CHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
                 tag:(int)tag;

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<CHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
                 tag:(int)tag;

// Synchronous request
+ (NSData *)sendSynWith:(NSString *)method
                    url:(NSString *)url
                  param:(NSDictionary *)param
               response:(NSURLResponse **)response
                  error:(NSError **)error;

@end
