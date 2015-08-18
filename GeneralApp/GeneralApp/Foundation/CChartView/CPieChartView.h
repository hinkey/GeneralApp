#import "CChartView.h"

@interface ChartViewSector : NSObject

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIColor *fillColor;
@property (nonatomic, assign) CGFloat value;

+ (id)sector;

@end

@class CPieChartView;
@protocol CPieChartViewDelegate <NSObject>

@optional
- (void)pieChartView:(CPieChartView *)view touchedAt:(NSInteger)index location:(CGPoint)point;

@end

@interface CPieChartView : CChartView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) id <CPieChartViewDelegate> chartdelegate;
@property (nonatomic, readonly) NSArray *sectors;    // 扇区 ChartViewSector

// 添加一个扇区
- (void)addSector:(ChartViewSector *)sector;

- (void)fillingSectors;
- (void)clearAllSectors;

@end
