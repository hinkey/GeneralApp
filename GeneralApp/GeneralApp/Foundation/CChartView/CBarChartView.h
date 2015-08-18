#import "CChartView.h"

@interface BarChartContent : NSObject

@property (nonatomic, copy) UIColor *color;
@property (nonatomic, strong) NSString *title;

@end

@interface ChartViewBarValue : NSObject

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) NSString *content;

@end

@interface ChartViewBarItem : UIView

@property (nonatomic, assign) NSInteger xvalue;
@property (nonatomic, strong) NSArray *valueArray; // ChartViewBarValue

+ (id)barItem;

@end


@class CBarChartView;
@protocol CBarChartViewDelegate <NSObject>

@required
- (void)barChartView:(CBarChartView *)view touchedBar:(ChartViewBarItem *)item index:(NSInteger)index;

@end

@interface CBarChartView : CChartView

@property (nonatomic, strong) NSArray *contents; // BarChartContent
@property (nonatomic, assign) id<CBarChartViewDelegate> chartdelegate;

// 添加一个柱状图对象
- (void)addBarItem:(ChartViewBarItem *)item;

- (void)fillingBars;
- (void)clearAllBars;

@end
