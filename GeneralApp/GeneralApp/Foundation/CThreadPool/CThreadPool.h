//
//  CThreadPool.h
//  GeneralApp
//
//  Created by hinkey on 15/8/16.
//  Copyright (c) 2015年 hinkey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CThreadPool : NSObject


// Concurrent or not, default is NO
// If concurrent needed, you must use lock to keep thread safe.
// If selector(s) to be performed contains sleep option, concurrent is recommended.
+ (void)setConcurrent:(BOOL)concurrent;

// Add a selector without object
+ (void)addTarget:(id)target sel:(SEL)selector;

// Add a selector with object
+ (void)addTarget:(id)target sel:(SEL)selector object:(id)object;

// Add a selectors without any object
// All selectors must be formatted to NSString object.
+ (void)addTarget:(id)target sels:(NSArray *)selectors;

@end
