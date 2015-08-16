//
//  UITextView+UAExtension.h
//  GeneralApp
//
//  Created by hinkey on 15/8/16.
//  Copyright (c) 2015年 hinkey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (UAExtension)

@property (nonatomic, copy)NSString *placeHolder;
@property (nonatomic, retain) UIFont *placeHolderFont;
@property (nonatomic, retain) UIColor *placeHolderColor;

- (CGFloat)contentWidth;
- (CGFloat)contentHeight;

@end
