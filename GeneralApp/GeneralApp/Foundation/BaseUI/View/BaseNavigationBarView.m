//
//  BaseNavigationBarView.m
//  UniversalApp
//
//  Created by Cailiang on 14/12/30.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import "BaseNavigationBarView.h"
#import "Constants.h"
#import "UILabel+UAExtension.h"

@interface BaseNavigationBarView ()

@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;

@end

@implementation BaseNavigationBarView

- (id)initWithFrame:(CGRect)frame
{
    CGRect frame_ = rectMake(0, 0, screenWidth(), naviHeight());
    self = [super initWithFrame:frame_];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - Properties

- (UILabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }
    
    CGFloat oringinX = naviButtonX() * 2 + naviButtonWidth();
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = rectMake(oringinX, 0, screenWidth() - oringinX * 2, naviHeight());
    titleLabel.backgroundColor = sysClearColor();
    titleLabel.textColor = sysWhiteColor();
    titleLabel.font = systemFont(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    return _titleLabel;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (_indicatorView) {
        return _indicatorView;
    }
    
    CGFloat oringingX = naviButtonWidth() + naviButtonX();
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]init];
    indicatorView.frame = rectMake(oringingX, 0, screenWidth() - oringingX * 2, naviHeight());
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _indicatorView = indicatorView;
    
    return _indicatorView;
}

#pragma mark - Setter & Getter

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)color
{
    _titleColor = color;
    self.titleLabel.textColor = color;
}

- (void)setEnableIndicator:(BOOL)enable
{
    if (enable) {
        if (_title && _title.length > 0) {
            CGFloat width = [self.titleLabel contentWidth];
            CGPoint center = self.titleLabel.center;
            self.indicatorView.center = CGPointMake(center.x - width / 2 - 15, center.y);
        }
        [self.indicatorView startAnimating];
        [self addSubview:self.indicatorView];
    } else {
        [self.indicatorView stopAnimating];
        [self.indicatorView removeFromSuperview];
    }
}

@end
