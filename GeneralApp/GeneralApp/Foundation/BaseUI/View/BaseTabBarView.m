//
//  BaseTabBarView.m
//  UniversalApp
//
//  Created by Cailiang on 14/12/30.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import "BaseTabBarView.h"
#import "Constants.h"

@implementation BaseTabBarView

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
        CGRect theframe = rectMake(0, screenHeight() - statusHeight() - tabHeight(), screenWidth(), tabHeight());
        [super setFrame:theframe];
    } else {
        [super setFrame:frame];
    }
}

@end
