//
//  BaseWebView.m
//  UniversalApp
//
//  Created by Cailiang on 15/3/18.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import "BaseWebView.h"
#import "Constants.h"
#import "CTimerBooster.h"
#import "NSObject+UAExtension.h"

@interface CProgressView : UIView

@property (nonatomic, assign) NSInteger progress; // Progress from 0 to 100
@property (nonatomic, assign) NSInteger maxProgressOfStep; // Default is 98
@property (nonatomic, copy) UIColor *progressColor; // Color of progress
@property (nonatomic, copy) UIColor *finishColor; // Color of finish , progress is 100

- (BOOL)canStep;
- (void)stepIt; // Every step is 1 0f 100, with animation
- (void)finish; // Set progress to 100, with animation
- (void)rollback; // Set progress from current to 0, with animation

@end

@interface CProgressView ()
{
    CGFloat _unitWidth; // 单元长度，总共100单元
}

@property (nonatomic, retain) UIImageView *stepView;

@end

@implementation CProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.progress = 0;
        self.maxProgressOfStep = 98;
        self.finishColor = sysWhiteColor();
        self.progressColor = sysLightGrayColor();
    }
    
    return self;
}

#pragma mark - Properties

- (UIImageView *)stepView
{
    if (_stepView) {
        return _stepView;
    }
    
    UIImageView *stepView = [[UIImageView alloc]init];
    [self addSubview:stepView];
    _stepView = stepView;
    
    return _stepView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _unitWidth = frame.size.width / 100.0;
    self.stepView.frame = rectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setProgress:(NSInteger)progress
{
    _progress = progress;
    _progress = (_progress < 0)?0:_progress;
    _progress = (_progress > 100)?100:_progress;
    
    CGRect frame = self.stepView.frame;
    self.stepView.frame = rectMake(0, 0, _unitWidth * _progress, frame.size.height);
    
    if (_progress == 100) {
        self.stepView.backgroundColor = self.finishColor;
    } else {
        self.stepView.backgroundColor = self.progressColor;
    }
}

- (BOOL)canStep
{
    return (_progress < _maxProgressOfStep)?YES:NO;
}

- (void)stepIt
{
    NSInteger progress = _progress + rand() % 40;
    progress = (progress > _maxProgressOfStep)?_maxProgressOfStep:progress;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.progress = progress;
    }];
}

- (void)finish
{
    [UIView animateWithDuration:0.25 animations:^{
        self.progress = 100;
    }];
}

- (void)rollback
{
    [UIView animateWithDuration:0.25 animations:^{
        self.progress = 0;
    }];
}

@end

@interface BaseWebView () <UIWebViewDelegate>

@property (nonatomic, retain) CProgressView *progressView;

@end

@implementation BaseWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // WebView
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
        [self addSubview:_webView];
        
        // Default
        self.enableProgress = YES;
    }
    
    return self;
}

- (void)dealloc
{
    // 移除进度模拟
    [CTimerBooster removeTarget:self sel:@selector(animateWithProgress)];
    
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    _webView = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Properties

- (CProgressView *)progressView
{
    if (_progressView) {
        return _progressView;
    }
    
    CProgressView *progressView = [[CProgressView alloc]init];
    progressView.backgroundColor = sysDarkGrayColor();
    progressView.progressColor = rgbColor(113, 205, 245);
    progressView.finishColor = sysLightGrayColor();
    [self addSubview:progressView];
    _progressView = progressView;
    
    return _progressView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_enableProgress) {
        self.progressView.frame = rectMake(0, 0, frame.size.width, 3);
        _webView.frame = rectMake(0, 3, frame.size.width, frame.size.height - 3);
    } else {
        _webView.frame = rectMake(0, 0, frame.size.width, frame.size.height);
    }
}

- (void)setEnableProgress:(BOOL)enable
{
    _enableProgress = enable;
    
    CGRect frame = self.frame;
    if (!enable) {
        [self.progressView removeFromSuperview];
        self.progressView = nil;
        
        _webView.frame = rectMake(0, 0, frame.size.width, frame.size.height);
        
        // 移除进度模拟
        [CTimerBooster removeTarget:self sel:@selector(animateWithProgress)];
    } else {
        self.progressView.frame = rectMake(0, 0, frame.size.width, 3);
        _webView.frame = rectMake(0, 3, frame.size.width, frame.size.height - 3);
        
        // 添加进度模拟
        [CTimerBooster addTarget:self sel:@selector(animateWithProgress) time:0.5 repeat:YES];
    }
}

- (NSURLRequest *)request
{
    return _webView.request;
}

- (BOOL)canGoBack
{
    return _webView.canGoBack;
}

- (BOOL)canGoForward
{
    return _webView.canGoForward;
}

- (BOOL)loading
{
    return _webView.loading;
}

- (BOOL)scalesPageToFit
{
    return _webView.scalesPageToFit;
}

- (void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    _webView.scalesPageToFit = scalesPageToFit;
}

- (BOOL)detectsPhoneNumbers
{
    return _webView.detectsPhoneNumbers;
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes
{
    _webView.dataDetectorTypes = dataDetectorTypes;
}

- (BOOL)allowsInlineMediaPlayback
{
    return _webView.allowsInlineMediaPlayback;
}

- (void)setAllowsInlineMediaPlayback:(BOOL)allowsInlineMediaPlayback
{
    _webView.allowsInlineMediaPlayback = allowsInlineMediaPlayback;
}

- (BOOL)mediaPlaybackRequiresUserAction
{
    return _webView.mediaPlaybackAllowsAirPlay;
}

- (void)setMediaPlaybackAllowsAirPlay:(BOOL)mediaPlaybackAllowsAirPlay
{
    _webView.mediaPlaybackAllowsAirPlay = mediaPlaybackAllowsAirPlay;
}

- (BOOL)suppressesIncrementalRendering
{
    return _webView.suppressesIncrementalRendering;
}

- (void)setSuppressesIncrementalRendering:(BOOL)suppressesIncrementalRendering
{
    _webView.suppressesIncrementalRendering = suppressesIncrementalRendering;
}

- (BOOL)keyboardDisplayRequiresUserAction
{
    return _webView.keyboardDisplayRequiresUserAction;
}

- (void)setKeyboardDisplayRequiresUserAction:(BOOL)keyboardDisplayRequiresUserAction
{
    _webView.keyboardDisplayRequiresUserAction = keyboardDisplayRequiresUserAction;
}

- (UIWebPaginationMode)paginationMode
{
    return _webView.paginationMode;
}

- (void)setPaginationMode:(UIWebPaginationMode)paginationMode
{
    _webView.paginationMode = paginationMode;
}

- (UIWebPaginationBreakingMode)paginationBreakingMode
{
    return _webView.paginationBreakingMode;
}

- (void)setPaginationBreakingMode:(UIWebPaginationBreakingMode)paginationBreakingMode
{
    _webView.paginationBreakingMode = paginationBreakingMode;
}

- (CGFloat)pageLength
{
    return _webView.pageLength;
}

- (void)setPageLength:(CGFloat)pageLength
{
    _webView.pageLength = pageLength;
}

- (CGFloat)gapBetweenPages
{
    return _webView.gapBetweenPages;
}

- (void)setGapBetweenPages:(CGFloat)gapBetweenPages
{
    _webView.gapBetweenPages = gapBetweenPages;
}

- (NSUInteger)pageCount
{
    return _webView.pageCount;
}

- (UIScrollView *)scrollView
{
    return _webView.scrollView;
}

#pragma mark - Methods

- (void)animateWithProgress
{
    [self runOnMainThread:@selector(animate)];
}

- (void)animate
{
    if (self.enableProgress && self.progressView.progress > 0 && [self.progressView canStep]) {
        [self.progressView stepIt];
    }
}

- (void)loadRequest:(NSURLRequest *)request
{
    [_webView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    [_webView loadHTMLString:string baseURL:baseURL];
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL
{
    [_webView loadData:data MIMEType:MIMEType textEncodingName:textEncodingName baseURL:baseURL];
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script
{
    return [_webView stringByEvaluatingJavaScriptFromString:script];
}

- (void)reload
{
    [_webView reload];
}

- (void)stopLoading
{
    [_webView stopLoading];
}

- (void)goBack
{
    [_webView goBack];
}

- (void)goForward
{
    [_webView goForward];
}

- (void)loadURL:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
}

- (void)loadURLString:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    [self loadURL:url];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (_delegate && [_delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [_delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (_delegate && [_delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        return [_delegate webViewDidStartLoad:webView];
    }
    
    if (self.enableProgress && self.progressView.progress % 100 == 0) {
        self.progressView.progress = 1;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_delegate && [_delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        return [_delegate webViewDidFinishLoad:webView];
    }
    
    if (self.enableProgress) {
        [self.progressView finish];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        return [_delegate webView:webView didFailLoadWithError:error];
    }
    
    if (self.enableProgress) {
        [self.progressView finish];
    }
}

@end
