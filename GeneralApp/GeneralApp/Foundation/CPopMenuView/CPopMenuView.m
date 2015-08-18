//
//  CPopMenuView.m
//  UniversalApp
//
//  Created by Cailiang on 15/7/17.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import "CPopMenuView.h"
#import "Constants.h"
#import "CPopMenuCell.h"

@interface CPopMenuView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *_tap;
}

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UITableView *contentView;

@end

@implementation CPopMenuView

- (id)init
{
    self = [super init];
    if (self) {
        _isHidden = YES;
    }
    
    return self;
}

#pragma mark - Properties

- (UIView *)backgroundView
{
    if (_backgroundView) {
        return _backgroundView;
    }
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.frame = rectMake(0, 0, screenWidth(), screenHeight());
    backgroundView.backgroundColor = sysClearColor();
    _backgroundView = backgroundView;
    
    // Tap gesture
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                  action:@selector(tapAction)];
    _tap.delegate = self;
    _tap.numberOfTapsRequired = 1;
    _tap.numberOfTouchesRequired = 1;
    [backgroundView addGestureRecognizer:_tap];
    
    return _backgroundView;
}

- (UITableView *)contentView
{
    if (_contentView) {
        return _contentView;
    }
    
    UITableView *contentView = [[UITableView alloc]init];
    contentView.dataSource = self;
    contentView.delegate = self;
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentView.backgroundColor = rgbaColor(0, 0, 0, 0.8);
    [self.backgroundView addSubview:contentView];
    _contentView = contentView;
    
    return _contentView;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSString *viewName = NSStringFromClass([touch.view class]);
    if ([viewName isEqualToString:@"UITableView"] ||
        [viewName isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataList) {
        return _dataList.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPopMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CPopMenuCell"];
    if (!cell) {
        registerCellNib(tableView, @"CPopMenuCell", @"CPopMenuCell");
        cell = [tableView dequeueReusableCellWithIdentifier:@"CPopMenuCell"];
    }
    
    [cell setCellData:_dataList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Hide
    [self hide];
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(popMenuViewDidSelect:)]) {
        [self.delegate popMenuViewDidSelect:indexPath.row];
    }
}
#pragma mark - Action

- (void)tapAction
{
    [self hide];
}

- (void)showInView:(UIView *)view origin:(CGPoint)point
{
    if (checkClass(view, UIView)) {
        _isHidden = NO;
        
        [view addSubview:self.backgroundView];
        
        self.backgroundView.alpha = 0;
        self.backgroundView.frame = rectMake(0, point.y, screenWidth(), screenHeight());
        self.contentView.frame = rectMake(point.x, 0, screenWidth() - point.x - 16, 200);
        
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundView.alpha = 1;
        }];
    }
}

- (void)hide
{
    _isHidden = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.backgroundView removeFromSuperview];
        }
    }];
}

@end
