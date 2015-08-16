#import "UIImageView+UAExtension.h"
#import "CHTTPDownloader.h"
#import "NSObject+UAExtension.h"

@implementation UIImageView (UAExtension)

- (UIColor*)colorForPoint:(CGPoint)point
{
    UIColor* color = nil;
    CGImageRef image = self.image.CGImage;
    CGContextRef context = [self contextFromCGImage:image];
    if (context == NULL) {
        return nil;
    }
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    CGFloat wscale = width / self.frame.size.width;
    CGFloat hscale = height / self.frame.size.height;
    CGPoint ipoint = CGPointMake(point.x * wscale, point.y * hscale);
    u_char* data = [self dataWith:image context:context];
    
    if (data != NULL) {
        @try {
            int offset = 4 * ((width * roundf(ipoint.y)) + roundf(ipoint.x));
            int red = data[offset];
            int green = data[offset + 1];
            int blue = data[offset + 2];
            int alpha = data[offset + 3];
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        }
        @catch (NSException * exception) {
            NSLog(@"%@",[exception reason]);
        }
    }
    CGContextRelease(context);
    
    if (data) {
        free(data);
        data = NULL;
    }
    
    return color;
}

- (u_char *)dataWith:(CGImageRef)image context:(CGContextRef)context
{
    @autoreleasepool
    {
        size_t width = CGImageGetWidth(image);
        size_t height = CGImageGetHeight(image);
        CGRect rect = {{0, 0}, {width, height}};
        CGContextDrawImage(context, rect, image);
        
        return CGBitmapContextGetData(context);
    }
}

- (CGContextRef)contextFromCGImage:(CGImageRef)image
{
    @autoreleasepool
    {
        CGContextRef context = NULL;
        CGColorSpaceRef colorSpace;
        size_t width = CGImageGetWidth(image);
        size_t height = CGImageGetHeight(image);
        int bytes = (int)(width * 4);
        int count = (int)(bytes * height);
        
        colorSpace = CGColorSpaceCreateDeviceRGB();
        if (colorSpace == NULL) {
            return NULL;
        }
        
        void *data = malloc(count);
        if (data == NULL) {
            CGColorSpaceRelease(colorSpace);
            return NULL;
        }
        
        int bitmapInfo = 0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
        bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
        bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
        
        context = CGBitmapContextCreate(data, width, height, 8, bytes, colorSpace, bitmapInfo);
        if (context == NULL) {
            free(data);
        }
        CGColorSpaceRelease(colorSpace);
        
        return context;
    }
}

- (void)setImage:(NSString *)url placeholder:(UIImage *)image
{
    // Place holder image
    self.image = image;
    
    NSMutableData *mdata = [NSMutableData data];
    NSString *local = [CHTTPDownloader downloadImage:url recevied:^(id data, long long receivedLength, long long expectedLength) {
        if (data) {
            [mdata appendData:data];
            [self setImage:[UIImage imageWithData:mdata]];
        }
    } callback:^(CHTTPStatus *status, id data) {
        if (status.code == CHTTPCodeOK) {
            [self setImage:[UIImage imageWithData:data]];
        }
    }];
    
    if (local) {
        NSData *data = [NSData dataWithContentsOfFile:local];
        self.image = [UIImage imageWithData:data];
    }
}

@end
