#import "CChartView.h"
#import "UILabel+UAExtension.h"

@implementation ChartViewCoordinate

@end

@interface CChartView () <UIScrollViewDelegate>
{
    NSMutableArray *_shapeArray;
    NSMutableArray *_labelArray;
}

@end

@implementation CChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置代理
        self.delegate = self;
        
        self.xlmargin = 20;
        self.xrmargin = 0;
        self.ytmargin = 20;
        self.ybmargin = 20;
        self.xspacing = 40;
        self.yspacing = 40;
        
        self.rulerWidth = 1.0;
        self.rulerColor = sysBlackColor();
        self.xmarkColor = sysBlackColor();
        self.ymarkColor = sysBlackColor();
        self.backgroundColor = sysWhiteColor();
    }
    
    return self;
}

- (void)dealloc
{
    // Clear chart
    [self removeChart];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (UIView *)leftView
{
    if (_leftView) {
        return _leftView;
    }
    
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = sysWhiteColor();
    [self addSubview:leftView];
    _leftView = leftView;
    
    return _leftView;
}

- (void)setBackgroundColor:(UIColor *)color
{
    [super setBackgroundColor:color];
    
    self.leftView.backgroundColor = color;
}

- (CGPoint)originPoint
{
    return pointMake(self.xlmargin, self.ytmargin + self.yspacing * (self.ycoordinates.count - 1));
}

- (CGFloat)unitXValue
{
    return self.xspacing * (self.xcoordinates.count - 1) / (self.xrange.max - self.xrange.min);
}

- (CGFloat)unitYValue
{
    return self.yspacing * (self.ycoordinates.count - 1) / (self.yrange.max - self.yrange.min);
}

#pragma mark - Methods

- (void)fillingChart
{
    @autoreleasepool
    {
        if (self.xcoordinates && self.ycoordinates) {
            if (!_labelArray) {
                _labelArray = [NSMutableArray array];
            }
            [_labelArray removeAllObjects];
            
            if (!_shapeArray) {
                _shapeArray = [NSMutableArray array];
            }
            [_shapeArray removeAllObjects];
            
            // 绘制坐标系
            [self resizeContent];
            [self fillingXCoordinate]; // Resize if needs
            [self fillingYCoordinate];
        }
    }
    
    self.contentOffset = CGPointZero;
    [self setNeedsDisplay];
}

- (void)removeChart
{
    @autoreleasepool
    {
        for (CAShapeLayer *shape in _shapeArray) {
            shape.path = nil;
            shape.fillColor = nil;
            shape.strokeColor = nil;
            [shape removeAllAnimations];
            [shape removeFromSuperlayer];
        }
        [_shapeArray removeAllObjects];
        
        for (UILabel *label in _labelArray) {
            [label removeFromSuperview];
        }
        [_labelArray removeAllObjects];
        
        if (_leftView) {
            [self.leftView removeFromSuperview];
            self.leftView = nil;
        }
    }
}

- (void)resizeContent
{
    @autoreleasepool
    {
        CGFloat maxWidth = 0;
        for (int i = 0; i < _ycoordinates.count; i ++) {
            NSInteger index = _ycoordinates.count - 1 - i;
            ChartViewCoordinate *coordinate = (ChartViewCoordinate *)_ycoordinates[index];
            
            // Y刻度标题
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.backgroundColor = sysClearColor();
            titleLabel.font = systemFont(12);
            titleLabel.textColor = _ymarkColor;
            titleLabel.text = coordinate.title;
            titleLabel.textAlignment = NSTextAlignmentRight;
            [_labelArray addObject:titleLabel];
            
            CGFloat topGap = (_ytmargin + i * _yspacing - 14/2.0);
            topGap = (i == _ycoordinates.count - 1)?(topGap - 7):topGap; // Reset if needs
            topGap = (i < 0)?0:topGap;
            titleLabel.frame = rectMake(0, topGap, _xlmargin + 5, 14);
            
            CGFloat width = [titleLabel contentWidth];
            maxWidth = (width > maxWidth)?width:maxWidth;
            titleLabel = nil;
        }
        
        // Reset left margin
        self.xlmargin = (maxWidth + 10 > self.xlmargin)?maxWidth + 10:self.xlmargin;
        self.xspacing = (self.xlmargin + 10 > self.xspacing)?self.xlmargin + 10:self.xspacing;
        
        CGFloat contentWidth = _xlmargin + _xrmargin + _xspacing * (_xcoordinates.count - 1) + _rulerWidth;
        CGFloat contentHeight = _ytmargin + _ybmargin + _yspacing * (_ycoordinates.count - 1);
        self.contentSize = CGSizeMake(contentWidth, contentHeight);
        self.leftView.frame = rectMake(0, 0, _xlmargin, contentHeight);
    }
}

- (void)fillingXCoordinate
{
    @autoreleasepool
    {
        CGFloat offset = _rulerWidth / 2;
        for (int i = 0; i < _xcoordinates.count; i ++) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:pointMake(_xlmargin + i * _xspacing + offset, _ytmargin - offset)];
            [path addLineToPoint:pointMake(_xlmargin + i * _xspacing + offset, _ytmargin + (_ycoordinates.count - 1) * _yspacing + offset)];
            [path closePath];
            
            CAShapeLayer *xshape = [CAShapeLayer layer];
            xshape.path = path.CGPath;
            xshape.strokeColor = [_rulerColor CGColor];
            xshape.fillColor = sysWhiteColor().CGColor;
            xshape.lineWidth = _rulerWidth;
            [_shapeArray addObject:xshape];
            
            if (i == 0) {
                [self.leftView.layer addSublayer:xshape];
            } else {
                [self.layer addSublayer:xshape];
                [self.layer insertSublayer:xshape below:self.leftView.layer];
            }
            xshape = nil;
            
            // X刻度标题
            ChartViewCoordinate *coordinate = (ChartViewCoordinate *)_xcoordinates[i];
            if (coordinate.title && coordinate.title.length > 0) {
                CGFloat contentHeight = self.contentSize.height;
                UILabel *titleLabel = [[UILabel alloc]init];
                titleLabel.backgroundColor = sysClearColor();
                titleLabel.font = systemFont(12);
                titleLabel.textColor = _xmarkColor;
                titleLabel.text = coordinate.title;
                [self addSubview:titleLabel];
                [self insertSubview:titleLabel belowSubview:self.leftView];
                [_labelArray addObject:titleLabel];
                
                CGFloat leftGap = 0;
                if (i == 0) {
                    titleLabel.textAlignment = NSTextAlignmentLeft;
                    leftGap = _xlmargin + offset;
                } else if (i == _xcoordinates.count - 1) {
                    titleLabel.textAlignment = NSTextAlignmentRight;
                    leftGap = _xlmargin + (i - 1) * _xspacing + _rulerWidth;
                } else {
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    leftGap = _xlmargin + i * _xspacing - _xspacing / 2.0 + offset;
                }
                titleLabel.frame = rectMake(leftGap, contentHeight - _ytmargin, _xspacing, _ytmargin);
                titleLabel = nil;
            }
        }
    }
}

- (void)fillingYCoordinate
{
    @autoreleasepool
    {
        for (int i = 0; i < _ycoordinates.count; i ++) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:pointMake(_xlmargin, _ytmargin + i * _yspacing)];
            [path addLineToPoint:pointMake(_xlmargin + _xspacing * (_xcoordinates.count - 1), _ytmargin + i * _yspacing)];
            [path closePath];
            
            CAShapeLayer *yshape = [CAShapeLayer layer];
            yshape.path = path.CGPath;
            yshape.strokeColor = [_rulerColor CGColor];
            yshape.fillColor = sysWhiteColor().CGColor;
            yshape.lineWidth = _rulerWidth;
            [self.layer addSublayer:yshape];
            [self.layer insertSublayer:yshape below:self.leftView.layer];
            [_shapeArray addObject:yshape];
            yshape = nil;
            path = nil;
            
            // Y Resize
            UILabel *titleLabel = _labelArray[i];
            CGRect frame = titleLabel.frame;
            titleLabel.frame = rectMake(0, frame.origin.y, self.xlmargin - 5, frame.size.height);
            [self.leftView addSubview:titleLabel];
            titleLabel = nil;
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    // 保持leftView始终在最右侧
    CGFloat leftGap = (offset.x < 0)?0:offset.x;
    CGRect frame = self.leftView.frame;
    self.leftView.frame = rectMake(leftGap, frame.origin.y, frame.size.width, frame.size.height);
}

@end
