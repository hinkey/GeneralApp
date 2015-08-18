//
//  BaseWebView.h
//  UniversalApp
//
//  Created by Cailiang on 15/3/18.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseWebView;
@protocol BaseWebViewDelegate <NSObject>

/*
 * UIWebViewDelegate
 */

@optional

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end

@interface BaseWebView : UIView
{
    UIWebView *_webView;
}

// Progress of webView loaded, default is YES
@property (nonatomic, assign) BOOL enableProgress;

/*
 * UIWebView properties
 */

@property (nonatomic, assign) id <BaseWebViewDelegate> delegate;

@property (nonatomic, readonly, retain) NSURLRequest *request;

@property (nonatomic, readonly, getter=canGoBack) BOOL canGoBack;

@property (nonatomic, readonly, getter=canGoForward) BOOL canGoForward;

@property (nonatomic, readonly, getter=isLoading) BOOL loading;

@property (nonatomic, assign) BOOL scalesPageToFit;

@property (nonatomic, assign) BOOL detectsPhoneNumbers NS_DEPRECATED_IOS(2_0, 3_0);

@property (nonatomic, assign) UIDataDetectorTypes dataDetectorTypes NS_AVAILABLE_IOS(3_0);

 // iPhone Safari defaults to NO. iPad Safari defaults to YES
@property (nonatomic, assign) BOOL allowsInlineMediaPlayback NS_AVAILABLE_IOS(4_0);

 // iPhone and iPad Safari both default to YES
@property (nonatomic, assign) BOOL mediaPlaybackRequiresUserAction NS_AVAILABLE_IOS(4_0);

 // iPhone and iPad Safari both default to YES
@property (nonatomic, assign) BOOL mediaPlaybackAllowsAirPlay NS_AVAILABLE_IOS(5_0);

 // iPhone and iPad Safari both default to NO
@property (nonatomic, assign) BOOL suppressesIncrementalRendering NS_AVAILABLE_IOS(6_0);

 // default is YES
@property (nonatomic, assign) BOOL keyboardDisplayRequiresUserAction NS_AVAILABLE_IOS(6_0);

@property (nonatomic, assign) UIWebPaginationMode paginationMode NS_AVAILABLE_IOS(7_0);

@property (nonatomic, assign) UIWebPaginationBreakingMode paginationBreakingMode NS_AVAILABLE_IOS(7_0);

@property (nonatomic, assign) CGFloat pageLength NS_AVAILABLE_IOS(7_0);

@property (nonatomic, assign) CGFloat gapBetweenPages NS_AVAILABLE_IOS(7_0);

@property (nonatomic, readonly) NSUInteger pageCount NS_AVAILABLE_IOS(7_0);

@property (nonatomic, readonly, retain) UIScrollView *scrollView NS_AVAILABLE_IOS(5_0);

/*
 * UIWebView methods
 */

- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;
- (void)reload;
- (void)stopLoading;
- (void)goBack;
- (void)goForward;

/*
 * Extension
 */

- (void)loadURL:(NSURL *)url;
- (void)loadURLString:(NSString *)string;

@end
