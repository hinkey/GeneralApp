//
//  CLineChartView.m
//  CLineCharView
//
//  Created by Cailiang on 15/3/10.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import "CLineChartView.h"
#import "UIButton+UAExtension.h"

@implementation ChartViewLinePoint

@end

@implementation ChartViewLine

+ (id)line
{
    @autoreleasepool
    {
        return [[ChartViewLine alloc]init];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        self.color = sysBlackColor();
        self.animation = NO;
        self.duration = 0.25;
    }
    
    return self;
}

@end

@interface CLineChartView ()
{
    BOOL _isRefresh;
    UIView *_canvas;
    NSMutableArray *_shapes;
    NSMutableArray *_buttons;
}

@end

@implementation CLineChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isRefresh = NO;
        self.clipsToBounds = YES;
        _shapes = [NSMutableArray array];
        _buttons = [NSMutableArray array];
    }
    
    return self;
}

- (void)dealloc
{
    [self clearLines];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)clearLines
{
    @autoreleasepool
    {
        for (CAShapeLayer *shape in _shapes) {
            shape.path = nil;
            shape.fillColor = nil;
            shape.strokeColor = nil;
            [shape removeAllAnimations];
            [shape removeFromSuperlayer];
        }
        [_shapes removeAllObjects];
        
        for (UIButton *button in _buttons) {
            [button removeFromSuperview];
        }
        [_buttons removeAllObjects];
        
        [_canvas removeFromSuperview];
        _canvas = nil;
    }
    
    [self setNeedsDisplay];
}

- (void)fillingLines
{
    [self fillingChart];
    
    for (int i = 0; i < _lines.count; i ++) {
        [self fillingLineAtIndex:i];
    }
    
    [self setNeedsDisplay];
}

- (void)fillingLineAtIndex:(NSInteger)index
{
    @autoreleasepool
    {
        if (!_canvas) {
            _canvas = [[UIView alloc]init];
            _canvas.frame = rectMake(0, 0, self.contentSize.width, self.contentSize.width);
        }
        [self addSubview:_canvas];
        [self insertSubview:_canvas belowSubview:self.leftView];
        
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.lineCap = kCALineCapRound;
        shape.lineJoin = kCALineJoinBevel;
        shape.fillColor = sysWhiteColor().CGColor;
        shape.lineWidth = 2.0;
        shape.strokeEnd = 0.0;
        [_canvas.layer addSublayer:shape];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
        [path setLineCapStyle:kCGLineCapRound];
        [path setLineJoinStyle:kCGLineJoinRound];
        
        ChartViewLine *line = self.lines[index];
        CGPoint origin = pointMake(self.xlmargin, self.contentSize.height - self.ybmargin);
        for (int i = 0; i < line.points.count; i ++) {
            ChartViewLinePoint *point = line.points[i];
            CGFloat xrate = 0;
            CGFloat yrate = 0;
            CGFloat xcenter = 0;
            CGFloat ycenter = 0;
            
            xrate = point.point.x / (self.xrange.max - self.xrange.min);
            yrate= point.point.y / (self.yrange.max - self.yrange.min);
            xcenter = origin.x + xrate * (self.contentSize.width - self.xlmargin - self.xrmargin) + self.rulerWidth / 2;
            ycenter = origin.y - (origin.y - self.ybmargin) * yrate;
            
            if (i == 0) {
                // 移动到起点
                [path moveToPoint:pointMake(xcenter, ycenter)];
            }
            [path addLineToPoint:pointMake(xcenter, ycenter)];
            [path moveToPoint:pointMake(xcenter, ycenter)];
            
            // Title
            CGFloat xvalue = xcenter;
            CGFloat minxcenter = self.xlmargin + self.rulerWidth / 2 + self.xspacing / 2;
            xvalue = (xvalue < minxcenter)?minxcenter:xvalue;
            __autoreleasing UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.frame = rectMake(0, 0, self.xspacing, 16);
            titleLabel.center = pointMake(xvalue, ycenter - 10);
            titleLabel.text = point.title;
            titleLabel.font = systemFont(10);
            titleLabel.backgroundColor = sysClearColor();
            titleLabel.textAlignment = (xvalue == minxcenter)?NSTextAlignmentLeft:NSTextAlignmentCenter;
            titleLabel.userInteractionEnabled = NO;
            [_canvas addSubview:titleLabel];
            
            // Action
            __autoreleasing UIButton *button = [UIButton customButton];
            button.frame = rectMake(0, 0, 20, 20);
            button.center = pointMake(xcenter, ycenter);
            button.tag = index * 10000 + i;
            [button addTarget:self action:@selector(pointAction:)];
            [self addSubview:button];
            [self insertSubview:button aboveSubview:_canvas];
            [self insertSubview:button belowSubview:self.leftView];
            [_buttons addObject:button];
            
            // Point tag
            __autoreleasing UIImageView *pointView = [[UIImageView alloc]init];
            pointView.frame = rectMake(0, 0, 8, 8);
            pointView.center = pointMake(10, 10);
            pointView.backgroundColor = self.backgroundColor;
            pointView.userInteractionEnabled = NO;
            pointView.layer.masksToBounds = YES;
            pointView.layer.cornerRadius = 4;
            pointView.layer.borderWidth = 2;
            pointView.layer.borderColor = line.color.CGColor;
            [button addSubview:pointView];
        }
        
        if (line.animation) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.duration = line.points.count * line.duration;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.fromValue = [NSNumber numberWithFloat:0.0f];
            animation.toValue = [NSNumber numberWithFloat:1.0f];
            animation.autoreverses = NO;
            [shape addAnimation:animation forKey:@"strokeEndAnimation"];
        }
        
        shape.path = path.CGPath;
        shape.strokeColor = line.color.CGColor;
        shape.strokeEnd = 1.0;
        
        [_shapes addObject:shape];
    }
}

- (void)pointAction:(UIButton *)button
{
    NSInteger indexOfLine = button.tag / 10000;
    NSInteger indexOfPoint = fmodf(button.tag, 10000);
    
    if (_chartdelegate && [_chartdelegate respondsToSelector:@selector(lineChartView:touchedLine:atIndex:)]) {
        [_chartdelegate lineChartView:self touchedLine:_lines[indexOfLine] atIndex:indexOfPoint];
    }
}

#pragma mark - Outer methods

- (void)addLine:(ChartViewLine *)line
{
    @autoreleasepool
    {
        if (line && checkClass(line, ChartViewLine)) {
            __autoreleasing NSMutableArray *lines = nil;
            if (_lines) {
                lines = [NSMutableArray arrayWithArray:_lines];
            } else {
                lines = [NSMutableArray array];
            }
            
            [lines addObject:line];
            _lines = [lines copy];
        }
    }
}

- (void)removeAllLines
{
    @autoreleasepool
    {
        for (int i = 0; i < _lines.count; i ++) {
            [self removeLineAtIndex:i];
        }
        
        for (UIButton *button in _buttons) {
            [button removeFromSuperview];
        }
        [_buttons removeAllObjects];
        
        _lines = nil;
        
        [_canvas removeFromSuperview];
        _canvas = nil;
    }
}

- (void)removeLineAtIndex:(NSInteger)index
{
    @autoreleasepool
    {
        NSMutableArray *lines = [NSMutableArray arrayWithArray:_lines];
        for (int i = 0; i < lines.count; i ++) {
            if (i == index) {
                ChartViewLine *line = lines[index];
                line.title = nil;
                line.points = nil;
                line.color = nil;
                
                // 移除该线数据
                [lines removeObjectAtIndex:index];
                [self removeShapeAtIndex:index];
            }
        }
        
        _lines = [lines copy];
    }
}

- (void)removeShapeAtIndex:(NSInteger)index
{
    @autoreleasepool
    {
        for (int i = 0; i < _shapes.count; i ++) {
            if (i == index) {
                CAShapeLayer *shape = _shapes[index];
                shape.path = nil;
                shape.fillColor = nil;
                shape.strokeColor = nil;
                [shape removeAllAnimations];
                [_shapes removeObjectAtIndex:index];
                
                UIButton *button = _buttons[index];
                [button removeFromSuperview];
                [_buttons removeObjectAtIndex:index];
            }
        }
    }
}

@end
