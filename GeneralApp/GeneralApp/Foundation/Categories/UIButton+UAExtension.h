//
//  UIButton+UAExtension.h
//
//  Created by Cailiang on 10/19/07.
//  Copyright 2007 Cailiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIButton (UAExtension)

// Custom button
+ (instancetype)customButton;

// Add Target and action with UIControlEventTouchDown
- (void)addTouchDownTarget:(id)target action:(SEL)action;

// Add Target and action with UIControlEventTouchUpInside
- (void)addTarget:(id)target action:(SEL)action;

// Set title with UIControlStateNormal
- (void)setTitle:(NSString *)title;

// Set title with UIControlStateSelected
- (void)setSTitle:(NSString *)title;

// Set title with UIControlStateHighlighted
- (void)setHTitle:(NSString *)title;

// Set title with UIControlStateDisabled
- (void)setDTitle:(NSString *)title;

// Set title color with UIControlStateNormal
- (void)setTitleColor:(UIColor *)color;

// Set title color with UIControlStateSelected
- (void)setSTitleColor:(UIColor *)color;

// Set title color with UIControlStateHighlighted
- (void)setHTitleColor:(UIColor *)color;

// Set title color with UIControlStateDisabled
- (void)setDTitleColor:(UIColor *)color;

// Set title font
- (void)setTitleFont:(UIFont *)font;

// Set number of line
- (void)setNumberofLines:(NSUInteger)number;

// Set Image with UIControlStateNormal
- (void)setImage:(UIImage *)image;

// Set Image with UIControlStateSelected
- (void)setSImage:(UIImage *)image;

// Set Image with UIControlStateHighlighted
- (void)setHImage:(UIImage *)image;

// Set Image with UIControlStateDisabled
- (void)setDImage:(UIImage *)image;

// Set Bacground Image with UIControlStateNormal
- (void)setBackgroundImage:(UIImage *)image;

// Set Bacground Image with UIControlStateSelected
- (void)setSBackgroundImage:(UIImage *)image;

// Set Bacground Image with UIControlStateHighlighted
- (void)setHBackgroundImage:(UIImage *)image;

// Set Bacground Image with UIControlStateDisabled
- (void)setDBackgroundImage:(UIImage *)image;

@end
