//
//  BaseTextField.h
//  UniversalApp
//
//  Created by Cailiang on 15/3/20.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTextField : UITextField

// 背景
@property (nonatomic, readonly) UIImageView *backgroundView;

// 边距(backgroundView to TextField)
@property (nonatomic, assign) UIEdgeInsets edgeInsets; // default is (5, 5, 5, 5)

// 监听文本输入
- (void)addTarget:(id)target action:(SEL)action;

@end
