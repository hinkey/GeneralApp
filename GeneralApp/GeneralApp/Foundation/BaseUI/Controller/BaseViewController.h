//
//  BaseViewController.h
//  UniversalApp
//
//  Created by Cailiang on 14/12/30.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "UIButton+UAExtension.h"
#import "NSObject+UAExtension.h"
#import "BaseNavigationBarView.h"
#import "BaseNavigationController.h"
#import "BaseTabBarView.h"
#import "ProgressHUD.h"
#import "AppUserInfo.h"

@interface BaseViewController : UIViewController

// Navigation bar
@property (nonatomic, retain) BaseNavigationBarView *navigationBar;

// Tab bar
@property (nonatomic, assign) BaseTabBarView *tabBar;

// The title of navigation bar
@property (nonatomic, copy) NSString *titleOfNavigation;

// Navigation bar hidden or not
@property (nonatomic, assign) BOOL navigationBarHidden;

// Back button, default is YES
@property (nonatomic, assign) BOOL showBackButton;

// Enable back button, default is YES
@property (nonatomic, assign) BOOL enableBackButton;

// Enable the drag to back interaction, Defalt is YES.
@property (nonatomic,assign) BOOL enablePanGesture;

// Content view
@property (nonatomic, retain) UIImageView *contentView;

// Pop count
@property (nonatomic, assign) NSUInteger countOfPop;

// Init
- (id)initWithData:(id)data;

// Attached view
- (void)addAttachedView:(UIView *)view;
- (void)removeAttachedView:(UIView *)view;
- (void)removeAllAttachedViews;

// NSNotificationCenter
- (void)addNotification:(NSString *)name sel:(SEL)selector;
- (void)removeNotification:(NSString *)name;
- (void)removeAllNotifications;

// Back action
- (void)backAction;

// Push & Pop
- (void)pushViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (UIViewController *)popViewController; // More safer
- (UIViewController *)popViewControllerAnimated:(BOOL)animated; // More safer

// Move event callback
- (void)viewIsMoving;
- (void)viewWillMoveBack;
- (void)viewWillMovePop;
- (void)viewWillPop;

@end
