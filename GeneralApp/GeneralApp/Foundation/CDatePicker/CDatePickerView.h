#import <UIKit/UIKit.h>
#import "NSDate+UAExtension.h"
#import "NSString+UAExtension.h"

@class CDatePickerView;
@protocol CDatePickerViewDelegate <NSObject>

@required
- (void)datePickerViewCallback:(CDatePickerView *)view date:(NSDate *)date;

@end

@interface CDatePickerView : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) UIDatePickerMode datePickerMode; // Default is UIDatePickerModeDate
@property (nonatomic, retain) NSDate *maximumDate;
@property (nonatomic, retain) NSDate *minimumDate;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, assign) id<CDatePickerViewDelegate> delegate;

- (void)showInView:(UIView *)view;

@end
