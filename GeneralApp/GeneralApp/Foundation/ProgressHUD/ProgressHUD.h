#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

typedef NS_ENUM(NSUInteger, ProgressHUDMaskType)
{
    ProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    ProgressHUDMaskTypeClear,    // don't allow
    ProgressHUDMaskTypeBlack,    // don't allow and dim the UI in the back of the HUD
    ProgressHUDMaskTypeGradient  // don't allow and dim the UI with a a-la-alert-view bg gradient
};

@interface ProgressHUD : UIView

// UIStatusBarStyleDefault
+ (void)show;
+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status maskType:(ProgressHUDMaskType)maskType;
+ (void)showWithMaskType:(ProgressHUDMaskType)maskType;

+ (void)showSuccessWithStatus:(NSString*)string;
+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration;

+ (void)setStatus:(NSString*)string;

+ (void)dismiss;
+ (void)dismissWithSuccess:(NSString*)successString;
+ (void)dismissWithSuccess:(NSString*)successString afterDelay:(NSTimeInterval)seconds;
+ (void)dismissWithError:(NSString*)errorString;
+ (void)dismissWithError:(NSString*)errorString afterDelay:(NSTimeInterval)seconds;

+ (BOOL)isVisible;

// UIStatusBarStyleLightContent
+ (void)showLight;
+ (void)showLWithStatus:(NSString*)status;
+ (void)showLWithStatus:(NSString*)status maskType:(ProgressHUDMaskType)maskType;
+ (void)showLWithMaskType:(ProgressHUDMaskType)maskType;

+ (void)showLSuccessWithStatus:(NSString*)string;
+ (void)showLSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
+ (void)showLErrorWithStatus:(NSString *)string;
+ (void)showLErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration;

// Custom UIStatusBarStyle
+ (void)showWithStyle:(UIStatusBarStyle)style;
+ (void)showWithStatus:(NSString*)status style:(UIStatusBarStyle)style;
+ (void)showWithStatus:(NSString*)status maskType:(ProgressHUDMaskType)maskType style:(UIStatusBarStyle)style;
+ (void)showWithMaskType:(ProgressHUDMaskType)maskType style:(UIStatusBarStyle)style;

+ (void)showSuccessWithStatus:(NSString*)string style:(UIStatusBarStyle)style;
+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration style:(UIStatusBarStyle)style;
+ (void)showErrorWithStatus:(NSString *)string style:(UIStatusBarStyle)style;
+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration style:(UIStatusBarStyle)style;

@end
