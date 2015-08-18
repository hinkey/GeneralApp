//
//  RefreshConst.h
//  Refresh
//
//  Created by  on 14-1-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define Log(...) NSLog(__VA_ARGS__)
#else
#define Log(...)
#endif

// objc_msgSend
#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)


#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 文字颜色
#define RefreshLabelTextColor Color(150, 150, 150)

extern const CGFloat RefreshViewHeight;
extern const CGFloat RefreshFastAnimationDuration;
extern const CGFloat RefreshSlowAnimationDuration;

extern NSString *const RefreshBundleName;
#define RefreshSrcName(file) [RefreshBundleName stringByAppendingPathComponent:file]

extern NSString *const RefreshFooterPullToRefresh;
extern NSString *const RefreshFooterReleaseToRefresh;
extern NSString *const RefreshFooterRefreshing;

extern NSString *const RefreshHeaderPullToRefresh;
extern NSString *const RefreshHeaderReleaseToRefresh;
extern NSString *const RefreshHeaderRefreshing;
extern NSString *const RefreshHeaderTimeKey;

extern NSString *const RefreshContentOffset;
extern NSString *const RefreshContentSize;