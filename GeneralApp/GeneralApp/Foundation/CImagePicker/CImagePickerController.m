#import "CImagePickerController.h"
#import "Constants.h"

@implementation CImagePickerController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self setStatusBarHidden:NO];
}

- (void)setStatusBarHidden:(BOOL)hidden
{
    if (OSVersionFloat() < 7.0) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        [[UIApplication sharedApplication]setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationNone];
    } else {
        UIWindow *statusBarWindow = [(UIWindow *)[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
        CGRect frame = statusBarWindow.frame;
        
        if (hidden) {
            CGSize size = [UIApplication sharedApplication].statusBarFrame.size;
            frame.origin.y = -size.height;
        } else {
            frame.origin.y = 0;
        }
        
        statusBarWindow.frame = frame;
    }
}

@end
