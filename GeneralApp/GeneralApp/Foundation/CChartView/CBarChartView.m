//
//  CBarChartView.m
//  UniversalApp
//
//  Created by Cailiang on 15/7/21.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import "CBarChartView.h"
#import "UIButton+UAExtension.h"

@implementation BarChartContent

@end

@implementation ChartViewBarValue

@end

@implementation ChartViewBarItem

+ (id)barItem
{
    @autoreleasepool
    {
        return [[ChartViewBarItem alloc]init];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = sysClearColor();
    }
    
    return self;
}

@end

@interface CBarChartView ()
{
    NSMutableArray *_barItemArray;
}

@end

@implementation CBarChartView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)addBarItem:(ChartViewBarItem *)item
{
    @autoreleasepool
    {
        if (checkClass(item, ChartViewBarItem)) {
            if (!_barItemArray) {
                _barItemArray = [NSMutableArray array];
            }
            
            [_barItemArray addObject:item];
        }
    }
}

- (void)fillingBars
{
    if (!CGRectEqualToRect(self.frame, CGRectZero)) {
        [self drawContents];
        [self drawBars];
    }
}

- (void)clearAllBars
{
    if (_barItemArray) {
        for (ChartViewBarItem *bar in _barItemArray) {
            [bar removeFromSuperview];
        }
        [_barItemArray removeAllObjects];
    }
}

- (void)drawContents
{
    [self fillingChart];
}

- (void)drawBars
{
    CGPoint origin = self.originPoint;
    CGFloat width = self.xspacing / (self.contents.count + 1);
    CGFloat height = self.yspacing * (self.ycoordinates.count - 1);
    CGFloat originX = 0;
    CGFloat originY = height;
    CGFloat unitYValue = self.unitYValue;
    
    for (ChartViewBarItem *barItem in _barItemArray) {
        // Resize
        originX = self.xspacing * barItem.xvalue + width / 2;
        barItem.frame = rectMake(origin.x + originX, origin.y - height, width * self.contents.count, height);
        [self addSubview:barItem];
        [self insertSubview:barItem belowSubview:self.leftView];
        
        NSInteger bindex = [_barItemArray indexOfObject:barItem];
        CGFloat leftGap = 0;
        for (ChartViewBarValue *value in barItem.valueArray) {
            NSInteger vindex = [barItem.valueArray indexOfObject:value];
            BarChartContent *content = self.contents[vindex];
            CGFloat height = value.value * unitYValue;
            
            UIButton *button = [UIButton customButton];
            button.tag = bindex * 10 + vindex;
            button.frame = rectMake(leftGap, originY - height, width, height);
            button.backgroundColor = content.color;
            [button addTarget:self action:@selector(buttonAction:)];
            [barItem addSubview:button];
            
            leftGap += width;
        }
    }
}

- (void)buttonAction:(UIButton *)button
{
    NSInteger index = button.tag / 10;
    NSInteger subIndex = button.tag % 10;
    
    if (_chartdelegate && [_chartdelegate respondsToSelector:@selector(barChartView:touchedBar:index:)]) {
        [_chartdelegate barChartView:self touchedBar:_barItemArray[index] index:subIndex];
    }
}

@end
