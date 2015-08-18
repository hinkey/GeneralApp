//
//  BaseTabBarController.m
//  UniversalApp
//
//  Created by Cailiang on 15/3/24.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseViewController.h"

@interface BaseTabBarController ()
{
    BOOL _isControllersLoaded;
}

@end

@implementation BaseTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 自定义适配
    [self layoutForCustom];
}

- (void)layoutForCustom
{
    CGRect frame = CGRectZero;
    if (OSVersionFloat() >= 7.0) {
        frame = rectMake(0, screenHeight() - statusHeight() - tabHeight(), screenWidth(), tabHeight());
    } else {
        frame = rectMake(0, screenHeight() - tabHeight(), screenWidth(), tabHeight());
    }
    
    self.tabBar.frame = frame;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Properties

- (BaseTabBarView *)baseTabBar
{
    if (_baseTabBar) {
        return _baseTabBar;
    }
    
    BaseTabBarView *tabBar = [[BaseTabBarView alloc]init];
    tabBar.frame = rectMake(0, screenHeight() - tabHeight(), screenWidth(), tabHeight());
    tabBar.backgroundColor = sysWhiteColor();
    tabBar.userInteractionEnabled = YES;
    [self.view addSubview:tabBar];
    _baseTabBar = tabBar;
    
    return _baseTabBar;
}

@end
