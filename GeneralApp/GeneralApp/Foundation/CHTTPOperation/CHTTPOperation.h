//
//  CHTTPOperation.h
//  GeneralApp
//
//  Created by hinkey on 15/8/16.
//  Copyright (c) 2015年 hinkey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CHTTPCode)
{
    CHTTPCodeOffline                          = 0,
    
    CHTTPCodeOK                               = 200,
    CHTTPCodeCreated                          = 201,
    CHTTPCodeAccepted                         = 202,
    CHTTPCodeNonAuthoritativeInfo             = 203,
    CHTTPCodeNoContent                        = 204,
    CHTTPCodeResetContent                     = 205,
    CHTTPCodePartialContent                   = 206, // Surport resume downloading
    
    CHTTPCodeMultipleChoices                  = 300,
    CHTTPCodeMovedPermanently                 = 301,
    CHTTPCodeFound                            = 302,
    CHTTPCodeSeeOther                         = 303,
    CHTTPCodeNotModified                      = 304,
    CHTTPCodeUseProxy                         = 305,
    CHTTPCodeTemporaryRedirect                = 307,
    
    CHTTPCodeBadRequest                       = 400,
    CHTTPCodeUnauthorized                     = 401,
    CHTTPCodeForbidden                        = 403,
    CHTTPCodeNotFound                         = 404,
    CHTTPCodeMethodNotAllowed                 = 405,
    CHTTPCodeMethodNotAcceptable              = 406,
    CHTTPCodeProxyAuthenticationRequired      = 407,
    CHTTPCodeRequestTimeout                   = 408,
    CHTTPCodeConflict                         = 409,
    CHTTPCodeGone                             = 410,
    CHTTPCodeLengthRequired                   = 411,
    
    CHTTPCodeInternalServerError              = 500,
    CHTTPCodeNotImplemented                   = 501,
    CHTTPCodeBadGateway                       = 502,
    CHTTPCodeServiceUnavailable               = 503,
    CHTTPCodeGatewayTimeout                   = 504,
    CHTTPCodeHttpVersionNotSupported          = 505,
};

typedef NS_ENUM(NSInteger, CHTTPType)
{
    CHTTPTypeDefault        = 0,    // For text request
    CHTTPTypeImage          = 1,    // For image request, eg. UIImageView+UAExtension, UIButton+UAExtension
    CHTTPTypeDownload       = 2,    // For file download request
};



@interface CHTTPStatus : NSObject

@property (nonatomic, assign) CHTTPCode code;  //response code
@property (nonatomic, assign) CGFloat time;    //time of request used
@property (nonatomic, assign) NSString *url;

@end

@protocol CHTTPRequestDelegate <NSObject>

@required
- (void) requestFinishedCallback:(int)tag status:(CHTTPStatus *)status data:(id)data;

@optional
- (void) requestDidReceviedResponseCallback:(CHTTPStatus *)status;
- (void) requestDidReceviedDataCallback:(int)tag data:(id)data receivedLength:(long long)rlength
        expectedLength:(long long)elength;
@end

typedef void (^CHTTPReceivedResponseCallback)(CHTTPStatus *status);
typedef void (^CHTTPReceivedDataCallback)(id data, long long receivedLength, long long expectedLength);
typedef void (^CHTTPCallback)(CHTTPStatus *status, id data);

@interface CHTTPOperation : NSOperation

//tag
@property (nonatomic, readonly) int tag;

//target for downloader
@property (nonatomic, readonly) id<CHTTPRequestDelegate> delegate;

//type defualt id universal
@property (nonatomic, readonly) CHTTPType type;

//request of current
@property (nonatomic, readonly) NSURLRequest *request;

// Block style
- (id)initWithRequest:(NSURLRequest *)request callback:(CHTTPCallback)callback;

// Block style with recevied data
- (id)initWithRequest:(NSURLRequest *)request recevied:(CHTTPReceivedDataCallback)recevied callback:(CHTTPCallback)callback;

// Block style with recevied response & data
- (id)initWithRequest:(NSURLRequest *)request response:(CHTTPReceivedResponseCallback)response recevied:(CHTTPReceivedDataCallback)recevied callback:(CHTTPCallback)callback;

// Delegate
- (id)initWithRequest:(NSURLRequest *)request delegate:(id<CHTTPRequestDelegate>)delegate tag:(int)tag;

// Set request type
- (void)setType:(CHTTPType)type;

// Set timeout, seconds should not less than 1s
// Seconds default is 30s
- (void)setTimeout:(NSInteger)seconds;


// Set times of retry
// times default is 0
// If your request is no need to retry, you`d better not use it.
// For that, the operation may stay long in memory.
- (void)setRetryTimes:(NSUInteger)times;

// Time interval of retry, default is 5s
- (void)setRetryTimeInterval:(NSUInteger)timeInterval;

- (void)cancel;


@end




