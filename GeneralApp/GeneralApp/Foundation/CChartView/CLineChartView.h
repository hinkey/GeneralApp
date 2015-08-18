#import "CChartView.h"

@interface ChartViewLinePoint : NSObject

@property (nonatomic, strong) NSString *title;   // 标题
@property (nonatomic, assign) NSInteger tag;     // 标记
@property (nonatomic, assign) CGPoint point;     // 在坐标系中坐标
@property (nonatomic, assign) BOOL userInteractionEnabled; // 是否接收点击事件

@end

@interface ChartViewLine : NSObject

@property (nonatomic, strong) NSString *title;         // 标题
@property (nonatomic, assign) NSInteger tag;           // 标记
@property (nonatomic, copy) UIColor *color;            // 颜色
@property (nonatomic, strong) NSArray *points;         // 坐标点 ChartViewLinePoint
@property (nonatomic, assign) BOOL animation;          // 动画绘制 默认 NO
@property (nonatomic, assign) NSTimeInterval duration; // 每段线的绘制时间 默认 0.25s

+ (id)line;

@end

@class CLineChartView;
@protocol CLineChartViewDelegate <NSObject>

@required
- (void)lineChartView:(CLineChartView *)view touchedLine:(ChartViewLine *)line atIndex:(NSInteger)index;

@end

@interface CLineChartView : CChartView

@property (nonatomic, assign) id <CLineChartViewDelegate> chartdelegate;
@property (nonatomic, readonly) NSArray *lines;    // 线 ChartViewLine

// 添加一条线
- (void)addLine:(ChartViewLine *)line;

// 绘制线条(同时会绘制表格)
- (void)fillingLines;

// 清空当前绘制的线条
- (void)clearLines;

// 移除指定的Line
- (void)removeLineAtIndex:(NSInteger)index;

// 移除所有的线
- (void)removeAllLines;

@end
