//
//  BaseViewController.m
//  UniversalApp
//
//  Created by Cailiang on 14/12/30.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import "BaseViewController.h"
#import "UIView+UAExtension.h"

@interface BaseViewController () <BaseNavigationControllerDelegate>
{
    NSMutableArray *_attachedViews;
    NSMutableArray *_notifications;
}

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _countOfPop = 1;
    }
    
    return self;
}

- (id)initWithData:(id)data
{
    return [self initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = sysWhiteColor();
    
    // Do any additional setup after loading the view.
    self.navigationBar.backgroundColor = rgbColor(239, 239, 239);
    self.navigationBar.titleLabel.textColor = rgbColor(114, 114, 114);
    self.showBackButton = YES;
    self.enablePanGesture = YES;
    
    if (OSVersionFloat() < 7.0) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 自定义适配
    [self layoutForCustom];
    
    if (_titleOfNavigation) {
        self.navigationBar.title = _titleOfNavigation;
    }
    
    for (UIView *view in _attachedViews) {
        [view viewWillAppear];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (UIView *view in _attachedViews) {
        [view viewDidAppear];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    for (UIView *view in _attachedViews) {
        [view viewWillDisappear];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    for (UIView *view in _attachedViews) {
        [view viewDidDisappear];
    }
}

- (void)layoutForCustom
{
    if (self.navigationController) {
        if (checkClass(self.navigationController, BaseNavigationController)) {
            BaseNavigationController *navigationController = (BaseNavigationController *)self.navigationController;
            navigationController.basedelegate = self;
            navigationController.countOfPop = _countOfPop;
            
            // Real count
            _countOfPop = navigationController.countOfPop;
        }
        
        if (OSVersionFloat() >= 7.0) {
            self.view.bounds = rectMake(0, - statusHeight(), screenWidth(), screenHeight());
        }
    } else {
        if (OSVersionFloat() >= 7.0) {
            self.view.bounds = rectMake(0, - statusHeight(), screenWidth(), screenHeight());
            
            // Status bar
            BaseStatusBarView *statusBar = [[BaseStatusBarView alloc]init];
            statusBar.frame = rectMake(0, - statusHeight(), screenWidth(), statusHeight());
            statusBar.backgroundColor = sysBlackColor();
            [self.view addSubview:statusBar];
        }
    }
    
    if (OSVersionFloat() >= 7.0) {
        [self setNeedsStatusBarAppearanceUpdate];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self removeAllAttachedViews];
    [self removeAllNotifications];
    
    // Remove all subview from self.view
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Properties

- (BaseNavigationBarView *)navigationBar
{
    if (_navigationBar) {
        return _navigationBar;
    }
    
    BaseNavigationBarView *navigationBar = [[BaseNavigationBarView alloc]init];
    navigationBar.userInteractionEnabled = YES;
    [self.view addSubview:navigationBar];
    _navigationBar = navigationBar;
    
    return _navigationBar;
}

- (BaseTabBarView *)tabBar
{
    if (_tabBar) {
        return _tabBar;
    }
    
    BaseTabBarView *tabBar = [[BaseTabBarView alloc]init];
    tabBar.backgroundColor = sysWhiteColor();
    tabBar.userInteractionEnabled = YES;
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
    
    return _tabBar;
}

- (void)setTitleOfNavigation:(NSString *)title
{
    _titleOfNavigation = title;
    
    self.navigationBar.title = title;
}

- (void)setShowBackButton:(BOOL)show
{
    if (_showBackButton == show) {
        return;
    }
    
    _showBackButton = show;
    
    if (show) {
        UIButton *backButton = [UIButton customButton];
        backButton.frame = rectMake(naviButtonX(), naviButtonY(), naviButtonWidth(), naviButtonHeight());
        [backButton setBackgroundImage:loadImage(@"app_back")];
        [backButton addTarget:self action:@selector(backAction)];
        
        [self.navigationBar addSubview:backButton];
        self.navigationBar.leftButton = backButton;
    } else {
        if (self.navigationBar.leftButton) {
            [self.navigationBar.leftButton removeFromSuperview];
            self.navigationBar.leftButton = nil;
        }
    }
}

- (void)setEnableBackButton:(BOOL)enable
{
    _enableBackButton = enable;
    self.navigationBar.leftButton.enabled = enable;
}

- (void)setNavigationBarHidden:(BOOL)hidden
{
    self.navigationBar.hidden = hidden;
    
    if (_contentView) {
        if (hidden) {
            if (OSVersionFloat() >= 7.0) {
                _contentView.frame = rectMake(0, 0, screenWidth(), screenHeight() - statusHeight());
            } else {
                _contentView.frame = rectMake(0, 0, screenWidth(), screenHeight());
            }
        } else {
            _contentView.frame = rectMake(0, naviHeight(), screenWidth(), screenHeight() - statusHeight() - naviHeight());
        }
    }
}

- (UIImageView *)contentView
{
    if (_contentView) {
        return _contentView;
    }
    
    UIImageView *contentView = [[UIImageView alloc]init];
    contentView.frame = rectMake(0, naviHeight(), screenWidth(), screenHeight() - naviHeight() - statusHeight());
    contentView.userInteractionEnabled = NO;
    [self.view addSubview:contentView];
    _contentView = contentView;
    
    return _contentView;
}

- (void)setCountOfPop:(NSUInteger)count
{
    // countOfPop 不能少于1
    _countOfPop = (count < 1)?1:count;
    
    BaseNavigationController *navigationController = (BaseNavigationController *)self.navigationController;
    if (navigationController) {
        navigationController.countOfPop = _countOfPop;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)pushViewController:(UIViewController *)viewController
{
    [self pushViewController:viewController animated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UINavigationController *navi = self.navigationController;
    if (navi) {
        [navi pushViewController:viewController animated:animated];
    }
    
    navi = nil;
}

- (UIViewController *)popViewController
{
    return [self popViewControllerAnimated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    @autoreleasepool
    {
        UINavigationController *navi = self.navigationController;
        if (navi) {
            __weak UIViewController *viewController = (UIViewController *)[navi.viewControllers lastObject];
            if (viewController == self) {
                return [navi popViewControllerAnimated:animated];
            }
        }
        
        return nil;
    }
}

- (void)addAttachedView:(UIView *)view
{
    if (!_attachedViews) {
        _attachedViews = [NSMutableArray array];
    }
    
    if (view) {
        [view viewDidLoad];
        [_attachedViews addObject:view];
    }
}

- (void)removeAttachedView:(UIView *)view
{
    @autoreleasepool
    {
        if (_attachedViews) {
            [_attachedViews removeObject:view];
        }
    }
}

- (void)removeAllAttachedViews
{
    @autoreleasepool
    {
        if (_attachedViews) {
            [_attachedViews removeAllObjects];
        }
        _attachedViews = nil;
    }
}

- (void)addNotification:(NSString *)name sel:(SEL)selector
{
    if (_notifications) {
        _notifications = [NSMutableArray array];
    }
    
    if (name && selector) {
        [_notifications addObject:@{@"name":name, @"sel":NSStringFromSelector(selector)}];
        [NotificationDefaultCenter addObserver:self selector:selector name:name object:nil];
    }
}

- (void)removeNotification:(NSString *)name
{
    if (_notifications) {
        for (int i = 0; i < _notifications.count; i ++) {
            NSDictionary *dict = _notifications[i];
            if ([name isEqualToString:dict[@"name"]]) {
                [_notifications removeObject:dict];
            }
        }
    }
    
    [NotificationDefaultCenter removeObserver:self name:name object:nil];
}

- (void)removeAllNotifications
{
    if (_notifications) {
        for (NSDictionary *dict in _notifications) {
            NSString *name = dict[@"name"];
            [NotificationDefaultCenter removeObserver:self name:name object:nil];
        }
    }
    
    [NotificationDefaultCenter removeObserver:self];
    [_notifications removeAllObjects];
    _notifications = nil;
}

#pragma mark - Action

- (void)backAction
{
    if (self.navigationController) {
        [self popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - BaseNavigationControllerDelegate

- (void)viewIsMoving
{
    for (UIView *view in _attachedViews) {
        [view viewIsMoving];
    }
}

- (void)viewWillMoveBack
{
    for (UIView *view in _attachedViews) {
        [view viewWillMoveBack];
    }
}

- (void)viewWillMovePop
{
    for (UIView *view in _attachedViews) {
        [view viewWillMovePop];
    }
}

- (void)viewWillPop
{
    for (UIView *view in _attachedViews) {
        [view viewWillPop];
    }
}

@end
