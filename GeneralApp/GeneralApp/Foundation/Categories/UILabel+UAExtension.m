#import "UILabel+UAExtension.h"

@implementation UILabel (UAExtension)

- (CGFloat)contentWidth
{
    return [self contentSizeWith:MAXFLOAT height:self.frame.size.height].width;
}

- (CGFloat)contentHeight
{
    return [self contentSizeWith:self.frame.size.width height:MAXFLOAT].height;
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

@end
