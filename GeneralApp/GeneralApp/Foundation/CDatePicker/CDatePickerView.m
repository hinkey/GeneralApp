#import "CDatePickerView.h"
#import "Constants.h"
#import "UIButton+UAExtension.h"

#define DATEPICKER_W   240
#define DATEPICKER_H   266

@interface CDatePickerView () <UIGestureRecognizerDelegate>
{
    BOOL isCancel;
}

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, retain) UIView *mainBGView;
@property (nonatomic, retain) UIImageView *mainView;
@property (nonatomic, assign) UIDatePicker *picker;

@end

@implementation CDatePickerView

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectZero;
        self.title = @"请选择日期";
        self.startDate = [NSDate date];
        self.datePickerMode = UIDatePickerModeDate;
    }
    return self;
}

- (UIView *)mainBGView
{
    if (_mainBGView) {
        return _mainBGView;
    }
    
    UIView *mainBGView = [[UIView alloc]init];
    mainBGView.backgroundColor = rgbaColor(0, 0, 0, 0.6);
    _mainBGView = mainBGView;
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    [mainBGView addGestureRecognizer:tap];
    
    return _mainBGView;
}

- (UIImageView *)mainView
{
    if (_mainView) {
        return _mainView;
    }
    
    UIImageView *mainView = [[UIImageView alloc]init];
    mainView.userInteractionEnabled = YES;
    mainView.backgroundColor = sysWhiteColor();
    mainView.clipsToBounds = YES;
    mainView.layer.cornerRadius = 6;
    mainView.image = loadImage(@"app_background");
    [self.mainBGView addSubview:mainView];
    _mainView = mainView;
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = rectMake(10, 10, DATEPICKER_W - 20, 20);
    label.text = _title;
    label.font = systemFont(14);
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = sysClearColor();
    [_mainView addSubview:label];
    
    // Date
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.frame = rectMake(0, 30, DATEPICKER_W, 180);
    picker.datePickerMode = _datePickerMode;
    picker.date = _startDate;
    picker.backgroundColor = sysClearColor();
    [_mainView addSubview:picker];
    self.picker = picker;
    
    // Background image
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.frame = rectMake(0, 220, DATEPICKER_W, 46);
    bgView.image = loadImage(@"info_tab");
    bgView.userInteractionEnabled = YES;
    [_mainView addSubview:bgView];
    
    NSArray *titles = @[@"确定", @"取消"];
    CGFloat leftGap = 0;
    CGFloat width = (DATEPICKER_W - 2)/2;
    for (int i = 0; i < titles.count; i ++) {
        UIButton *button = [UIButton customButton];
        button.frame = rectMake(leftGap, 1, width, 45);
        [button setTitle:titles[i]];
        [button setTitleFont:systemFont(14)];
        [button setTitleColor:sysBlackColor()];
        [button setHTitleColor:rgbColor(240, 102, 44)];
        button.tag = i + 1;
        [button addTarget:self action:@selector(buttonAction:)];
        [bgView addSubview:button];
        
        leftGap += width + 1;
    }
    
    UIImageView *midLine = [[UIImageView alloc]init];
    midLine.frame = rectMake(DATEPICKER_W/2 - 1, 1, 2, 45);
    midLine.image = loadImage(@"info_navi_hline");
    //    midLine.backgroundColor = sysLightGrayColor();
    [bgView addSubview:midLine];
    
    //    // Confirm
    //    UIButton *confirmButton = [UIButton customButton];
    //    confirmButton.frame = rectMake(10, 240, DATEPICKER_W - 20, 40);
    //    confirmButton.layer.borderWidth = 0.4;
    //    confirmButton.layer.borderColor = sysGrayColor().CGColor;
    //    confirmButton.layer.cornerRadius = 6;
    //    [confirmButton setTitle:@"确定"];
    //    [confirmButton setTitleColor:sysBlackColor()];
    //    [confirmButton setTitleFont:systemFont(18)];
    //    [confirmButton addTarget:self action:@selector(confirmAction:)];
    //    [_mainView addSubview:confirmButton];
    
    return _mainView;
}

- (void)setStartDate:(NSDate *)date
{
    _startDate = date;
    
    self.picker.date = date;
}

#pragma mark - Method

- (void)hide
{
    CGFloat originX = (screenWidth() - DATEPICKER_W)/2;
    __weak CDatePickerView *weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.mainBGView.backgroundColor = rgbaColor(0, 0, 0, 0);
        weakself.mainView.frame = rectMake(originX, weakself.frame.size.height, DATEPICKER_W, DATEPICKER_H);
    } completion:^(BOOL finished) {
        if (finished) {
            [weakself.mainBGView removeFromSuperview];
        }
    }];
    
    NSDate *date = isCancel?self.startDate:self.picker.date;
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerViewCallback:date:)]) {
        [self.delegate datePickerViewCallback:self date:date];
    }
}

- (BOOL)isPoint:(CGPoint)point inRect:(CGRect)rect
{
    CGFloat xmin = rect.origin.x;
    CGFloat ymin = rect.origin.y;
    CGFloat xmax = rect.origin.x + rect.size.width;
    CGFloat ymax = rect.origin.y + rect.size.height;
    
    return (point.x >= xmin) && (point.x <= xmax) && (point.y >= ymin) && (point.y <= ymax);
}

#pragma mark - Action

- (void)tapAction:(UIGestureRecognizer *)recognizer
{
    [self hide];
    
    isCancel = YES;
}

- (void)buttonAction:(UIButton *)button
{
    if (button.tag == 1) {
        isCancel = NO;
    } else {
        isCancel = YES;
    }
    
    [self hide];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.mainView];
    if ([self isPoint:point inRect:self.mainView.bounds]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Out Method

- (void)showInView:(UIView *)view
{
    self.frame = rectMake(0, 0, screenWidth(), screenHeight() - statusHeight());
    self.mainBGView.frame = self.frame;
    [view addSubview:self.mainBGView];
    
    self.mainBGView.backgroundColor = rgbaColor(0, 0, 0, 0);
    
    CGFloat originY = (screenHeight() - statusHeight() - DATEPICKER_H)/2;
    CGFloat originX = (screenWidth() - DATEPICKER_W)/2;
    self.mainView.frame = rectMake(originX, self.frame.size.height, DATEPICKER_W, DATEPICKER_H);
    
    __weak CDatePickerView *weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.mainBGView.backgroundColor = rgbaColor(0, 0, 0, 0.6);
        weakself.mainView.frame = rectMake(originX, originY, DATEPICKER_W, DATEPICKER_H);
    }];
    
    self.picker.maximumDate = self.maximumDate;
    self.picker.minimumDate = self.minimumDate;
}

@end
