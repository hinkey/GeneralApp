//
//  NSObject+UAExtension.h
//  GeneralApp
//
//  Created by hinkey on 15/8/16.
//  Copyright (c) 2015年 hinkey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UAExtension)

// Run on main thread
- (void)runOnMainThread:(SEL)sel;
- (void)runOnMainThread:(SEL)sel withObject:(id)object;
- (void)runOnMainThread:(SEL)sel withObject:(id)object waitUntilDone:(BOOL)wait;

// Run after delay
- (void)runWithSelector:(SEL)sel afterDelay:(NSTimeInterval)time;
- (void)runWithSelector:(SEL)sel afterDelay:(NSTimeInterval)time repeat:(BOOL)repeat;
- (void)runWithSelector:(SEL)sel withObject:(id)object afterDelay:(NSTimeInterval)time;
- (void)runWithSelector:(SEL)sel withObject:(id)object afterDelay:(NSTimeInterval)time repeat:(BOOL)repeat;


@end
