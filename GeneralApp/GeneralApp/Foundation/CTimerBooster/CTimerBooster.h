//
//  CTimerBooster.h
//  GeneralApp
//
//  Created by hinkey on 15/8/16.
//  Copyright (c) 2015年 hinkey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTimerBooster : NSObject

// 开始频率Timer计时
+ (void)start;

// 检查是否已添加
+ (BOOL)isExistTarget:(id)target sel:(SEL)selector;

// 添加一个接收目标, 不重复执行
+ (void)addTarget:(id)target sel:(SEL)selector time:(NSTimeInterval)time;

// 添加一个接收目标
+ (void)addTarget:(id)target sel:(SEL)selector time:(NSTimeInterval)time repeat:(BOOL)repeat;

// 添加一个带参接收目标
+ (void)addTarget:(id)target sel:(SEL)selector object:(id)object time:(NSTimeInterval)time;

// 添加一个带参接收目标
+ (void)addTarget:(id)target
              sel:(SEL)selector
           object:(id)object
             time:(NSTimeInterval)time
           repeat:(BOOL)repeat;

// 移除一个接收目标
+ (void)removeTarget:(id)target sel:(SEL)selector;

// 关闭发生器
+ (void)kill;


@end
