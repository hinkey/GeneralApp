//
//  BaseNavigationBarView.h
//  UniversalApp
//
//  Created by Cailiang on 14/12/30.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationBarView : UIImageView

// 标题
@property (nonatomic, strong) NSString *title;

// 标题颜色
@property (nonatomic, retain) UIColor *titleColor;

// 标题标签
@property (nonatomic, strong) UILabel *titleLabel;

// 左按钮
@property (nonatomic, retain) UIButton *leftButton;

// 右按钮
@property (nonatomic, retain) UIButton *rightButton;

// 标题左侧Indicator
@property (nonatomic, assign) BOOL enableIndicator;

@end
