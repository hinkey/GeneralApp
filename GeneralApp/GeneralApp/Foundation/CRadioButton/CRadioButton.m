#import "CRadioButton.h"
#import "Constants.h"

@interface CRadioButton ()
{
    UIButton *_button;
    UIImage *_selectedImage;
    UIImage *_normalImage;
    UIImageView *_imageView;
    UILabel *_titleLabel;
    
    id __weak _target;
    SEL _action;
}

@end

@implementation CRadioButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 接收触摸消息
        self.userInteractionEnabled = YES;
        
        if (_imageView == nil) {
            _imageView = [[UIImageView alloc]init];
            _imageView.userInteractionEnabled = NO;
            
            [self addSubview:_imageView];
        }
        
        if (_titleLabel == nil) {
            _titleLabel = [[UILabel alloc]init];
            _titleLabel.userInteractionEnabled = NO;
            _titleLabel.textColor = sysBlackColor();
            _titleLabel.font = systemFont(15);
            _titleLabel.backgroundColor = sysClearColor();
            
            [self addSubview:_titleLabel];
        }
        
        if (_button == nil) {
            _button = [UIButton customButton];
            _button.backgroundColor = sysClearColor();
            [_button addTarget:self action:@selector(radioAction:)];
            [self addSubview:_button];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGSize size = frame.size;
    size.width = (size.width < 30)?30:size.width;
    size.height = (size.height < 30)?30:size.height;
    frame.size = size;
    
    [super setFrame:frame];
    
    _button.frame = rectMake(0, 0, size.width, size.height);
    CGFloat topGap = (size.height - 20)/2;
    _imageView.frame = rectMake(5, topGap, 20, 20);
    _titleLabel.frame = rectMake(30, 0, size.width - 30, size.height);
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        if (_selectedImage) {
            _imageView.image = _selectedImage;
            _imageView.layer.borderWidth = 0;
            _imageView.layer.borderColor = sysClearColor().CGColor;
            _imageView.layer.cornerRadius = 0;
        } else {
            _imageView.backgroundColor = rgbColor(247, 135, 59);
            _imageView.layer.borderWidth = 1.0;
            _imageView.layer.borderColor = sysBlackColor().CGColor;
            _imageView.layer.cornerRadius = 10;
        }
    } else {
        if (_normalImage) {
            _imageView.image = _normalImage;
            _imageView.layer.borderWidth = 0;
            _imageView.layer.borderColor = sysClearColor().CGColor;
            _imageView.layer.cornerRadius = 0;
        } else {
            _imageView.backgroundColor = sysClearColor();
            _imageView.layer.borderWidth = 1.0;
            _imageView.layer.borderColor = sysBlackColor().CGColor;
            _imageView.layer.cornerRadius = 10;
        }
    }
    
    _selected = selected;
}

#pragma mark - Action

- (void)radioAction:(UIButton *)button
{
    button.selected = !button.selected;
    self.selected = button.selected;
    
    if (_target && [_target respondsToSelector:_action]) {
        IMP imp = [_target methodForSelector:_action];
        void (*excute)(id, SEL, CRadioButton*) = (void *)imp;
        excute(_target, _action, self);
    }
}

#pragma mark - Out Method

+ (CRadioButton *)customButton
{
    return [[CRadioButton alloc]init];
}

// 添加按钮响应
- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

// 常态按钮图片
- (void)setNormalImage:(UIImage *)image
{
    if (checkClass(image, UIImage)) {
        _normalImage = image;
        _imageView.image = image;
    }
}

// 选中态按钮图片
- (void)setSeletedImage:(UIImage *)image
{
    if (checkClass(image, UIImage)) {
        _selectedImage = image;
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

@end