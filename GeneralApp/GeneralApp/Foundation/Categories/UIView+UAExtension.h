#import <UIKit/UIKit.h>

@interface UIViewReload : NSObject

@property(nonatomic, assign) SEL reloadDataAction;
@property(nonatomic, assign) id reloadDataTarget;

@end

@interface UIView (UAExtension)

@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;

@property (nonatomic, retain) UIViewReload *reloadInfo;

- (UIView *)clone;

// Super viewcontroller
- (UIViewController *)viewController;

// Super viewcontroller navigationController
- (UINavigationController *)navigationController;

// Origin
- (CGPoint)origin;

// Size
- (CGSize)size;

// For view controller vieWillApear call
- (void)viewWillAppear;

// For view controller vieWillDisapear call
- (void)viewWillDisappear;

// For view controller viewDidLoad call
- (void)viewDidLoad;

// For view controller viewDidAppear call
- (void)viewDidAppear;

// For view controller viewDidDisappear call
- (void)viewDidDisappear;

// For Move event callback
- (void)viewIsMoving;

// For Move event callback
- (void)viewWillMoveBack;

// For Move event callback
- (void)viewWillMovePop;

// For Move event callback
- (void)viewWillPop;

- (void)didReceiveMemoryWarning;

// 显示加载失败提示
- (void)showNetworkReload:(SEL)sel target:(id)target;

// 移除显示加载失败提示
- (void)removeNetworkReload;

// 显示加载框
- (void)showLoadingHUD;

// 隐藏加载框
- (void)hideHUDView;

@end
