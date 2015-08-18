#import <UIKit/UIKit.h>

@class CImagePickerView;
@protocol CImagePickerViewDelegate <NSObject>

@required

- (void)imagePickerViewCallback:(CImagePickerView *)view;

@end

@interface CImagePickerView : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) UIImage *image;
@property (nonatomic, assign) id<CImagePickerViewDelegate> delegate;

- (void)showInView:(UIView *)view;

@end
