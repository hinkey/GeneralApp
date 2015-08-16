//
//  UIView+WExtension.m
//  UniversalApp
//
//  Created by Cailiang on 14-9-16.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import "UIView+UAExtension.h"
#import "Constants.h"
#import "UIButton+UAExtension.h"
#import <objc/runtime.h>

@implementation UIViewReload

@end

@implementation UIView (UAExtension)

@dynamic indicatorView;
@dynamic reloadInfo;

- (UIView *)clone
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (UIViewController *)viewController
{
    UIResponder *responder = [self nextResponder];
    while (responder != nil) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return  (UIViewController*)responder;
        } else {
            responder = [responder nextResponder];
        }
    }
    
    return nil;
}

- (UINavigationController *)navigationController
{
    return self.viewController.navigationController;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGSize)size
{
    return self.frame.size;
}

// For view controller vieWillApear call
- (void)viewWillAppear
{
    //
}

// For view controller vieWillDisapear call
- (void)viewWillDisappear
{
    //
}

// For view controller viewDidLoad call
- (void)viewDidLoad
{
    //
}

// For view controller viewDidAppear call
- (void)viewDidAppear
{
    //
}

// For view controller viewDidDisappear call
- (void)viewDidDisappear
{
    //
}

// For Move event callback
- (void)viewIsMoving
{
    //
}

// For Move event callback
- (void)viewWillMoveBack
{
    //
}

// For Move event callback
- (void)viewWillMovePop
{
    //
}

// For Move event callback
- (void)viewWillPop
{
    //
}

- (void)didReceiveMemoryWarning
{
    //
}

- (UIActivityIndicatorView *)indicatorView
{
    UIActivityIndicatorView *_indicatorView = (UIActivityIndicatorView *)objc_getAssociatedObject(self, "indicatorViewKey");
    
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc]init];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _indicatorView.center = pointMake(30, 30);
        _indicatorView.layer.borderWidth = 1;
        _indicatorView.layer.cornerRadius = 6;
        _indicatorView.backgroundColor = rgbaColor(0, 0, 0, 0.8);
        [self addSubview:_indicatorView];
        
        objc_setAssociatedObject(self, "indicatorViewKey", _indicatorView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [self bringSubviewToFront:_indicatorView];
    return _indicatorView;
}

- (void)setIndicatorView:(UIActivityIndicatorView *)indicatorView
{
    objc_setAssociatedObject(self,"indicatorViewKey",indicatorView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewReload *)reloadInfo
{
    UIViewReload *_reloadInfo = (UIViewReload *)objc_getAssociatedObject(self,"reloadInfoKey");
    
    if (_reloadInfo == nil) {
        _reloadInfo = [[UIViewReload alloc]init];
        objc_setAssociatedObject(self,"reloadInfoKey", _reloadInfo,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _reloadInfo;
}

- (void)setReloadInfo:(UIViewReload *)reloadInfo
{
    objc_setAssociatedObject(self,"reloadInfoKey",reloadInfo,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 显示加载框
- (void)showLoadingHUD
{
    self.userInteractionEnabled = NO;
    
    CGRect frame = self.frame;
    self.indicatorView.frame = rectMake((frame.size.width - 60)/2, (frame.size.height - 60)/2, 60, 60);
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
}

// 隐藏加载框
- (void)hideHUDView
{
    self.userInteractionEnabled = YES;
    
    self.indicatorView.hidden = YES;
    [self.indicatorView stopAnimating];
}

- (void)showNetworkReload:(SEL)sel target:(id)target
{
    // 移除之前提示
    [self removeNetworkReload];
    
    self.reloadInfo.reloadDataAction = sel;
    self.reloadInfo.reloadDataTarget = target;
    
    UIButton *reloadButton = [UIButton customButton];
    reloadButton.frame = rectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [reloadButton addTarget:self action:@selector(reloadAction)];
    [reloadButton setTitle:NETWORK_RELOAD];
    [reloadButton setTitleFont:systemFont(16)];
    [reloadButton setTitleColor:sysLightGrayColor()];
    [reloadButton setNumberofLines:3];
    reloadButton.tag = 987654321;
    
    [self addSubview:reloadButton];
}

- (void)reloadAction
{
    [self removeNetworkReload];
    
    IMP imp = [self.reloadInfo.reloadDataTarget methodForSelector:self.reloadInfo.reloadDataAction];
    void (*excute)(id, SEL) = (void *)imp;
    excute(self.reloadInfo.reloadDataTarget, self.reloadInfo.reloadDataAction);
    
    self.reloadInfo.reloadDataTarget = nil;
    self.reloadInfo.reloadDataAction = nil;
    self.reloadInfo = nil;
}

- (void)removeNetworkReload
{
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (button.tag == 987654321) {
                [button removeFromSuperview];
            }
        }
    }
}

@end
