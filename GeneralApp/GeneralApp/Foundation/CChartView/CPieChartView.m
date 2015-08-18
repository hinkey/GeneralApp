#import "CPieChartView.h"
#import "UILabel+UAExtension.h"

@implementation ChartViewSector

+ (id)sector
{
    @autoreleasepool
    {
        return [[ChartViewSector alloc]init];
    }
}

@end

@interface CPieChartView ()
{
    CGFloat _totalValue;
    UILabel *_titleLabel;
    CGFloat _pieRadius;
    UIView *_backgroundView;
    
    NSMutableArray *_sectorArray;
    NSMutableArray *_lshapeArray;
    NSMutableArray *_sshapeArray;
    NSMutableArray *_labelArray;
}

@end

@implementation CPieChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _totalValue = 0;
        _pieRadius = 80;
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

- (NSArray *)sectors
{
    return _sectorArray;
}

- (void)addSector:(ChartViewSector *)sector
{
    @autoreleasepool
    {
        if (checkClass(sector, ChartViewSector)) {
            if (!_sectorArray) {
                _sectorArray = [NSMutableArray array];
            }
            
            _totalValue += sector.value;
            [_sectorArray addObject:sector];
        }
    }
}

- (void)fillingSectors
{
    if (!CGRectEqualToRect(self.frame, CGRectZero)) {
        [self drawContents];
        [self drawSectors];
    }
}

- (void)drawContents
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame = rectMake(0, 20, self.frame.size.width, 20);
        _titleLabel.font = boldSystemFont(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = sysClearColor();
        [self addSubview:_titleLabel];
    }
    _titleLabel.text = _title;
    
    if (!_backgroundView) {
        CGFloat originX = self.frame.size.width / 2.0 - _pieRadius;
        CGFloat originY = self.frame.size.height / 2.0 - _pieRadius;
        
        _backgroundView = [[UIView alloc]init];
        _backgroundView.frame = rectMake(originX, originY, _pieRadius * 2.0, _pieRadius * 2.0);
        _backgroundView.backgroundColor = sysWhiteColor();
        _backgroundView.layer.cornerRadius = _pieRadius;
        _backgroundView.layer.borderColor = sysClearColor().CGColor;
        _backgroundView.userInteractionEnabled = YES;
        [self addSubview:_backgroundView];
        
        // Tap action
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [tap addTarget:self action:@selector(tapAction:)];
        [_backgroundView addGestureRecognizer:tap];
    }
}

- (void)drawSectors
{
    @autoreleasepool
    {
        if (!_lshapeArray) {
            _lshapeArray = [NSMutableArray array];
        }
        
        if (!_sshapeArray) {
            _sshapeArray = [NSMutableArray array];
        }
        
        if (!_labelArray) {
            _labelArray = [NSMutableArray array];
        }
        
        CGFloat startAngle = M_PI_2 * 3;
        CGFloat textRadius = _pieRadius + 10;
        CGFloat width = self.frame.size.width / 2 - textRadius;
        
        for (ChartViewSector *sector in _sectorArray) {
            CAShapeLayer *sectorShape = [CAShapeLayer layer];
            sectorShape.lineCap = kCALineCapButt;
            sectorShape.lineJoin = kCALineJoinBevel;
            sectorShape.strokeColor = sector.fillColor.CGColor;
            sectorShape.fillColor = sector.fillColor.CGColor;
            [_backgroundView.layer addSublayer:sectorShape];
            [_sshapeArray addObject:sectorShape];
            
            // Sector
            CGFloat angleValue = (sector.value / _totalValue) * 2 * M_PI;
            CGFloat endAngle = startAngle + angleValue;
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, &CGAffineTransformIdentity, _pieRadius, _pieRadius);
            CGPathAddArc(path, &CGAffineTransformIdentity, _pieRadius, _pieRadius, _pieRadius, startAngle, endAngle, NO);
            sectorShape.path = path;
            CGPathRelease(path);
            
            // Origin
            CGFloat angle = startAngle - M_PI_2 * 3 + angleValue / 2.0;
            CGFloat centerX = _backgroundView.center.x +  textRadius * sinf(angle);
            CGFloat centerY = _backgroundView.center.y - textRadius * cosf(angle);
            
            // Title
            UILabel *label = [[UILabel alloc]init];
            label.frame = rectMake(0, 0, width, 40);
            label.text = sector.title;
            label.font = systemFont(11);
            label.textColor = sysDarkGrayColor();
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            label.backgroundColor = sysClearColor();
            [self addSubview:label];
            [_labelArray addObject:label];
            
            // Indicator shape
            CAShapeLayer *lineShape = [CAShapeLayer layer];
            lineShape.lineCap = kCALineCapRound;
            lineShape.lineJoin = kCALineJoinBevel;
            lineShape.fillColor = sector.fillColor.CGColor;
            lineShape.strokeColor = sector.fillColor.CGColor;
            lineShape.lineWidth = 1;
            [self.layer addSublayer:lineShape];
            [_lshapeArray addObject:lineShape];
            
            CGFloat cx = _backgroundView.center.x + _pieRadius * sinf(angle) / 2.0;
            CGFloat cy = _backgroundView.center.y - _pieRadius * cosf(angle) / 2.0;
            UIBezierPath *lpath = [UIBezierPath bezierPath];
            [lpath moveToPoint:pointMake(cx, cy)];
            [lpath addLineToPoint:pointMake(centerX, centerY)];
            [lpath closePath];
            lineShape.path = lpath.CGPath;
            
            CGFloat contentWidth = [label contentWidth];
            CGFloat contentHeight = [label contentHeight];
            
            contentWidth = (contentWidth > width)?width:contentWidth;
            contentHeight = (contentHeight > 40)?40:contentHeight;
            
            // Resize
            CGFloat originX = centerX;
            CGFloat originY = centerY;
            CGFloat delta = M_PI_2 / 10;
            angle = fmodf(angle, M_PI * 2);
            
            if (angle <= delta || angle >= M_PI * 2 - delta) {
                originX -= contentWidth / 2.0;
                originY -= contentHeight;
            } else if (angle >= (M_PI - delta) && angle <= M_PI + delta) {
                originX -= contentWidth / 2.0;
            } else if (angle > delta && angle < M_PI - delta) {
                originY -= contentHeight / 2.0;
            } else if (angle > M_PI + delta && angle < M_PI * 2 - delta) {
                originX -= contentWidth;
                originY -= contentHeight / 2.0;
            }
            
            label.frame = rectMake(originX, originY, contentWidth, contentHeight);
            
            startAngle += angleValue;
        }
        
        [_backgroundView setNeedsLayout];
    }
}

- (void)clearAllSectors
{
    @autoreleasepool
    {
        _totalValue = 0;
        [_sectorArray removeAllObjects];
        
        for (CAShapeLayer *shape in _lshapeArray) {
            shape.path = NULL;
            [shape removeFromSuperlayer];
        }
        [_lshapeArray removeAllObjects];
        
        for (CAShapeLayer *shape in _sshapeArray) {
            shape.path = NULL;
            [shape removeFromSuperlayer];
        }
        [_sshapeArray removeAllObjects];
        
        for (UILabel *label in _labelArray) {
            label.text = nil;
            [label removeFromSuperview];
        }
        [_labelArray removeAllObjects];
    }
}

- (void)tapAction:(UIGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:_backgroundView];
    for (CAShapeLayer *shape in _sshapeArray) {
        if (CGPathContainsPoint(shape.path, &CGAffineTransformIdentity, point, NO)) {
            NSInteger index = [_sshapeArray indexOfObject:shape];
            
            if (_chartdelegate && [_chartdelegate respondsToSelector:@selector(pieChartView:touchedAt:location:)]) {
                [_chartdelegate pieChartView:self touchedAt:index location:point];
            }
            
            break;
        }
    }
}

@end
