//
//  BaseTextField.m
//  UniversalApp
//
//  Created by Cailiang on 15/3/20.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import "BaseTextField.h"
#import "Constants.h"
#import "NSObject+UAExtension.h"


@interface BaseTextField ()

@end

@implementation BaseTextField

@synthesize backgroundView = _backgroundView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _edgeInsets = UIEdgeInsetsZero;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.superview && !self.backgroundView.superview) {
        UIView *superview = self.superview;
        [superview addSubview:self.backgroundView];
        [superview insertSubview:self.backgroundView belowSubview:self];
    }
}

#pragma - mark - Properties

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!CGRectEqualToRect(frame, CGRectZero)) {
        self.backgroundView.frame = frame;
        if (UIEdgeInsetsEqualToEdgeInsets(_edgeInsets, UIEdgeInsetsZero)) {
            self.edgeInsets = edgeMake(5, 5, 5, 5);
        } else {
            self.edgeInsets = _edgeInsets;
        }
    }
}

- (UIImageView *)backgroundView
{
    if (_backgroundView) {
        return _backgroundView;
    }
    
    UIImageView *backgroundView = [[UIImageView alloc]init];
    backgroundView.userInteractionEnabled = YES;
    _backgroundView = backgroundView;
    
    return _backgroundView;
}

- (void)setEdgeInsets:(UIEdgeInsets)edge
{
    _edgeInsets = edge;
    
    CGRect frame = self.backgroundView.frame;
    if (!CGRectEqualToRect(frame, CGRectZero)) {
        CGFloat width = frame.size.width - edge.left - edge.right;
        CGFloat height = frame.size.height - edge.top - edge.bottom;
        frame = rectMake(frame.origin.x + edge.left, frame.origin.y + edge.top, width, height);
    }
    
    [super setFrame:frame];
}

#pragma mark - Methods

- (void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventEditingChanged];
}

@end
