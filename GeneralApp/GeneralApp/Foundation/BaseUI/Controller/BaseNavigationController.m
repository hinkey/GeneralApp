//
//  BaseNavigationController.m
//  UniversalApp
//
//  Created by Cailiang on 14-9-17.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"
#import "BaseTabBarController.h"

@interface BaseNavigationController () <UIGestureRecognizerDelegate>
{
    UIPanGestureRecognizer *_recognizer;
}

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) UIImageView *lastScreenView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *screenList;
@property (nonatomic, assign) BOOL isMoving;

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _countOfPop = 1;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Default is black color
    [self statusBar];
    
    _screenList = [NSMutableArray array];
    self.enablePanGesture = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_screenList removeAllObjects];
    _screenList = nil;
    
    [_backgroundView removeFromSuperview];
    _backgroundView = nil;
    
    [_shadowView removeFromSuperview];
    _shadowView = nil;
    
    if (_recognizer) {
        _recognizer.delegate = nil;
        [_recognizer removeTarget:self action:@selector(panGestureAction:)];
        [self.view removeGestureRecognizer:_recognizer];
    }
    _recognizer = nil;
}

#pragma mark - Override Push & Pop

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    @autoreleasepool
    {
        dismiss();
        
        [_screenList addObject:[self screenCapture]];
        _lastScreenView.transform = CGAffineTransformMakeTranslation(- screenWidth() * 0.25, 0);
        
        [super pushViewController:viewController animated:animated];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    @autoreleasepool
    {
        dismiss();
        
        if (_basedelegate && [_basedelegate respondsToSelector:@selector(viewWillPop)]) {
            [_basedelegate viewWillPop];
        }
        
        UIViewController *theController = nil;
        if (_countOfPop == 1) {
            theController =  [super popViewControllerAnimated:animated];
        } else {
            NSArray *viewControllers = self.viewControllers;
            NSUInteger index = self.viewControllers.count - _countOfPop - 1;
            theController = viewControllers[index];
            [super popToViewController:theController animated:animated];
        }
        
        [_screenList removeLastObject];
        
        return theController;
    }
}

#pragma mark - Properties

- (BaseStatusBarView *)statusBar
{
    if (OSVersionFloat() >= 7.0) {
        if (_statusBar) {
            return _statusBar;
        }
        
        BaseStatusBarView *statusBar = [[BaseStatusBarView alloc]init];
        statusBar.backgroundColor = sysBlackColor();
        [self.view addSubview:statusBar];
        _statusBar = statusBar;
        
        return _statusBar;
    } else {
        return nil;
    }
}

- (void)setCountOfPop:(NSUInteger)count
{
    _countOfPop = (count < 1)?1:count;
    
    if (self.viewControllers) {
        NSInteger count = self.viewControllers.count;
        _countOfPop = (count <= _countOfPop)?count - 1:_countOfPop;
    }
}

- (void)setEnablePanGesture:(BOOL)enable
{
    if (enable) {
        if (_recognizer == nil) {
            _recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
            _recognizer.delegate = self;
            _recognizer.maximumNumberOfTouches = 1;
            _recognizer.delaysTouchesBegan = YES;
            [self.view addGestureRecognizer:_recognizer];
        }
    } else {
        if (_recognizer) {
            _recognizer.delegate = nil;
            [_recognizer removeTarget:self action:@selector(panGestureAction:)];
            [self.view removeGestureRecognizer:_recognizer];
        }
        _recognizer = nil;
    }
    
    _enablePanGesture = enable;
}

#pragma mark - Out Method

- (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)gesture
{
    [_recognizer requireGestureRecognizerToFail:gesture];
}

#pragma mark -  Action

- (void)panGestureAction:(UIPanGestureRecognizer *)recoginzer
{
    @autoreleasepool
    {
        CGPoint touchPoint = [recoginzer locationInView:getKeyWindow()];
        if (recoginzer.state == UIGestureRecognizerStateBegan) {
            _isMoving = YES;
            _startPoint = touchPoint;
            
            if (!_backgroundView) {
                CGRect frame = self.view.frame;
                
                _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
                [self.view.superview insertSubview:_backgroundView belowSubview:self.view];
                
                _shadowView = [[UIView alloc]init];
                _shadowView.frame = CGRectMake(0, statusHeight(), frame.size.width , frame.size.height);
                _shadowView.backgroundColor = sysBlackColor();
                [_backgroundView addSubview:_shadowView];
            }
            
            _backgroundView.hidden = NO;
            
            NSUInteger requiredCount = self.viewControllers.count - _countOfPop;
            NSUInteger currentCount = _screenList.count;
            if (requiredCount < currentCount) {
                for (int i = 0; i < currentCount - requiredCount; i ++) {
                    [_screenList removeLastObject];
                }
            }
            
            if (_lastScreenView) {
                _lastScreenView.image = nil;
                [_lastScreenView removeFromSuperview];
                _lastScreenView = nil;
            }
            _lastScreenView = [[UIImageView alloc]initWithImage:[_screenList lastObject]];
            [_backgroundView insertSubview:_lastScreenView belowSubview:_shadowView];
            
        } else if (recoginzer.state == UIGestureRecognizerStateEnded) {
            if (touchPoint.x - _startPoint.x > 30) {
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    [self moveViewWithX:screenWidth()];
                } completion:^(BOOL finished) {
                    [self popViewControllerAnimated:NO];
                    
                    CGRect frame = self.view.frame;
                    frame.origin.x = 0;
                    self.view.frame = frame;
                    
                    _isMoving = NO;
                    if (_basedelegate && [_basedelegate respondsToSelector:@selector(viewWillMovePop)]) {
                        [_basedelegate viewWillMovePop];
                    }
                }];
            } else {
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    [self moveViewWithX:0];
                } completion:^(BOOL finished) {
                    _isMoving = NO;
                    _backgroundView.hidden = YES;
                    if (_basedelegate && [_basedelegate respondsToSelector:@selector(viewWillMoveBack)]) {
                        [_basedelegate viewWillMoveBack];
                    }
                }];
                
            }
            return;
            
        } else if (recoginzer.state == UIGestureRecognizerStateCancelled) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                _backgroundView.hidden = YES;
            }];
            
            return;
        }
        
        if (_isMoving) {
            [self moveViewWithX:touchPoint.x - _startPoint.x];
        }
    }
}

#pragma mark - View moving

- (void)moveViewWithX:(float)x
{
    x = (x > screenWidth())?screenWidth():x;
    x = (x < 0)?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    // Alpha
    float alpha = (1.0 - x / screenWidth())* 0.25;
    _shadowView.alpha = alpha;
    
    // Last screen
    CGFloat rate = (OSVersionFloat() >= 7.0)?0.3:1.0;
    _lastScreenView.transform = CGAffineTransformMakeTranslation((x - screenWidth()) * rate, 0);
    
    if (x > 0) {
        if (_basedelegate && [_basedelegate respondsToSelector:@selector(viewIsMoving)]) {
            [_basedelegate viewIsMoving];
        }
    }
}

#pragma mark - Screen Capture

- (UIImage *)screenCapture
{
    @autoreleasepool
    {
        UIGraphicsBeginImageContextWithOptions(screenSize(), self.view.opaque, 0.0);
        [getAppWindow().layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSInteger count = self.viewControllers.count;
    if (count == 1) {
        return NO;
    }
    
    BaseViewController *viewController = (BaseViewController *)self.topViewController;
    if ((checkClass(viewController, BaseViewController) &&
        !viewController.enablePanGesture) ||
        checkClass(viewController, BaseTabBarController)) {
        return NO;
    }
    
    NSString *viewName = NSStringFromClass([touch.view class]);
    if ([touch.view isKindOfClass:[UIButton class]] ||
        [viewName isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    
    return YES;
}

@end
