#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ChartViewCoordinate : NSObject

@property (nonatomic, strong) NSString *title;   // 标题

@end

@interface CChartView : UIScrollView

@property (nonatomic, strong) NSArray *xcoordinates;   // x坐标点 ChartViewCoordinate
@property (nonatomic, strong) NSArray *ycoordinates;   // y坐标点 ChartViewCoordinate
@property (nonatomic, assign) CGFloat xlmargin;        // x坐标边距 默认 20px
@property (nonatomic, assign) CGFloat ytmargin;        // y坐标边距 默认 20px
@property (nonatomic, assign) CGFloat xrmargin;        // x坐标边距 默认 0px
@property (nonatomic, assign) CGFloat ybmargin;        // y坐标边距 默认 20px
@property (nonatomic, assign) CGFloat xspacing;        // x坐标间距 默认 40px
@property (nonatomic, assign) CGFloat yspacing;        // y坐标间距 默认 40px
@property (nonatomic, assign) CGRange xrange;          // x值域
@property (nonatomic, assign) CGRange yrange;          // y值域

@property (nonatomic, retain) UIView *leftView;         // 左边坐标侧栏
@property (nonatomic, copy) UIColor *rulerColor;        // 网格线颜色 默认 黑色
@property (nonatomic, assign) CGFloat rulerWidth;       // 网格线宽度 默认 1px
@property (nonatomic, copy) UIColor *xmarkColor;        // x刻度颜色 默认 黑色
@property (nonatomic, copy) UIColor *ymarkColor;        // y刻度颜色 默认 黑色

@property (nonatomic, readonly) CGPoint originPoint;    // Point of origin, Atfer all value filled.
@property (nonatomic, readonly) CGFloat unitYValue;     // Length of y unit, Atfer all value filled.
@property (nonatomic, readonly) CGFloat unitXValue;     // Length of x unit, Atfer all value filled.

- (void)fillingChart;
- (void)removeChart;

@end