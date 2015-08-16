#import "UITextView+UAExtension.h"
#import "UILabel+UAExtension.h"
#import <objc/runtime.h>

@implementation UITextView (UAExtension)

@dynamic placeHolder;
@dynamic placeHolderFont;
@dynamic placeHolderColor;

- (void)setPlaceHolder:(NSString *)placeHolder
{
    UILabel *holderLabel = [self getPlaceHolder];
    holderLabel.text = placeHolder;
    CGFloat height = [holderLabel contentHeight];
    CGFloat leftGap = ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)?8:5;
    holderLabel.frame = CGRectMake(leftGap, 8, self.frame.size.width, height);
}

- (void)setPlaceHolderColor:(UIColor *)color
{
    [self getPlaceHolder].textColor = color;
}

- (void)setPlaceHolderFont:(UIFont *)font
{
    [self getPlaceHolder].font = font;
}

- (UILabel *)getPlaceHolder
{
    UILabel *holderLabel = (UILabel *)objc_getAssociatedObject(self,"placeHolderKey");
    if (holderLabel == nil) {
        holderLabel = [[UILabel alloc]init];
        holderLabel.backgroundColor = [UIColor clearColor];
        holderLabel.textColor = [UIColor lightGrayColor];
        holderLabel.font = self.font;
        holderLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:holderLabel];
        objc_setAssociatedObject(self,"placeHolderKey", holderLabel,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(textViewDidChangeNotification:)
                                                    name:UITextViewTextDidChangeNotification
                                                  object:nil];
    }
    
    return holderLabel;
}

- (void)textViewDidChangeNotification:(NSNotification *)notification
{
    UILabel *holderLabel = (UILabel *)objc_getAssociatedObject(self,"placeHolderKey");
    if (self.text && self.text.length > 0) {
        if (holderLabel) {
            holderLabel.hidden = YES;
        }
    } else {
        if (holderLabel) {
            holderLabel.hidden = NO;
        }
    }
}

- (CGSize)contentSizeWith:(CGFloat)width height:(CGFloat)height
{
    CGSize size = CGSizeZero;
    
    CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
    if (version >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:self.font,
                                     NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        size = [self.text boundingRectWithSize:CGSizeMake(width, height)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes context:nil].size;
    } else {
        size = [self.text sizeWithFont:self.font];
    }
    
    size.height = ceil(size.height);
    size.width = ceil(size.width);
    
    return size;
}

#pragma mark - Out Method

- (CGFloat)contentWidth
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0) {
        return self.contentSize.width;
    } else {
        CGSize size = self.frame.size;
        size = [self contentSizeWith:size.width height:size.height];
        return size.width + 10;
    }
    
    return 0;
}

- (CGFloat)contentHeight
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0) {
        return self.contentSize.width;
    } else {
        CGSize size = self.frame.size;
        size = [self contentSizeWith:size.width height:size.height];
        return size.height + 16;
    }
    
    return 0;
}

@end
