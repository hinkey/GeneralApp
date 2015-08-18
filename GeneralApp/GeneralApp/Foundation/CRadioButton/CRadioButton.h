#import "UIButton+UAExtension.h"

@interface CRadioButton : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *title;

+ (CRadioButton *)customButton;

// 添加按钮响应
- (void)addTarget:(id)target action:(SEL)action;

// 常态按钮图片
- (void)setNormalImage:(UIImage *)image;

// 选中态按钮图片
- (void)setSeletedImage:(UIImage *)image;

@end
