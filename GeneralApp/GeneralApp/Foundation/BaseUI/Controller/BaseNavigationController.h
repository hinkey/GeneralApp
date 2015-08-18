//
//  BaseNavigationController.h
//  UniversalApp
//
//  Created by Cailiang on 14-9-17.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+UAExtension.h"
#import "BaseStatusBarView.h"

@protocol BaseNavigationControllerDelegate <NSObject>

@optional

// Drag callback
- (void)viewIsMoving;
- (void)viewWillMoveBack;
- (void)viewWillMovePop;
- (void)viewWillPop;

@end

@interface BaseNavigationController : UINavigationController

// Status bar
@property (nonatomic, retain) BaseStatusBarView *statusBar;

// Pop to controller with index, default is 1
@property (nonatomic, assign) NSUInteger countOfPop;

// Enable the drag to back interaction, Defalt is YES.
@property (nonatomic,assign) BOOL enablePanGesture;

// BaseNavigationControllerDelegate delegate
@property (nonatomic,assign) id<BaseNavigationControllerDelegate> basedelegate;

- (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)gesture;

@end
