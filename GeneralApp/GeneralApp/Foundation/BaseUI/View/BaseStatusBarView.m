//
//  BaseStatusBarView.m
//  UniversalApp
//
//  Created by Cailiang on 14/12/30.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import "BaseStatusBarView.h"
#import "Constants.h"

@implementation BaseStatusBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = rectMake(0, 0, screenWidth(), statusHeight());
    }
    
    [super setFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
