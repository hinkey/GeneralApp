//
//  CSelectionDialog.m
//  UniversalApp
//
//  Created by Cailiang on 14/11/10.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import "CSelectionDialog.h"
#import "Constants.h"
#import "BaseTableView.h"
#import "UIButton+UAExtension.h"
#import "NSObject+UAExtension.h"
#import "CSelectionDialogCell.h"

#define SEL_DIALOG_W 240
#define SEL_DIALOG_H 200

@interface CSelectionDialog () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, retain) UIView *mainBGView;
@property (nonatomic, retain) UIImageView *mainView;
@property (nonatomic, strong) BaseTableView *mainTable;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *buttonView;

@end

@implementation CSelectionDialog

- (id)init
{
    self = [super init];
    if (self) {
        _title = @"请选择";
        self.mainView.frame = CGRectZero;
    }
    return self;
}

#pragma mark - Properties

- (UIView *)mainBGView
{
    if (_mainBGView) {
        return _mainBGView;
    }
    
    UIView *mainBGView = [[UIView alloc]init];
    mainBGView.userInteractionEnabled = YES;
    mainBGView.backgroundColor = rgbaColor(0, 0, 0, 0.6);
    _mainBGView = mainBGView;
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    [mainBGView addGestureRecognizer:tap];
    
    return _mainBGView;
}

- (UIImageView *)mainView
{
    if (_mainView) {
        return _mainView;
    }
    
    UIImageView *mainView = [[UIImageView alloc]init];
    mainView.userInteractionEnabled = YES;
    mainView.backgroundColor = sysWhiteColor();
    mainView.layer.cornerRadius = 6;
    mainView.clipsToBounds = YES;
    [self.mainBGView addSubview:mainView];
    _mainView = mainView;
    
    // Add title
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = rectMake(10, 5, SEL_DIALOG_W - 20, 30);
    titleLabel.font = systemFont(16);
    titleLabel.textColor = sysBlackColor();
    titleLabel.backgroundColor = sysClearColor();
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_mainView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    // Line
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = sysLightGrayColor();
    line.frame = rectMake(0, 39.7, SEL_DIALOG_W, 0.3);
    [_mainView addSubview:line];
    
    // Add buttons & lines
    [_mainView addSubview:self.buttonView];
    
    return _mainView;
}

- (BaseTableView *)mainTable
{
    if (_mainTable) {
        return _mainTable;
    }
    
    _mainTable = [[BaseTableView alloc]init];
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.dataSource = self;
    _mainTable.delegate = self;
    _mainTable.backgroundColor = sysClearColor();
    [self.mainView addSubview:_mainTable];
    
    return _mainTable;
}

- (UIImageView *)buttonView
{
    if (_buttonView) {
        return _buttonView;
    }
    
    UIImageView *buttonView = [[UIImageView alloc]init];
    buttonView.frame = rectMake(0, SEL_DIALOG_H - 46, SEL_DIALOG_W, 46);
    buttonView.backgroundColor = sysWhiteColor();
    buttonView.userInteractionEnabled = YES;
    [self.mainView addSubview:buttonView];
    _buttonView = buttonView;
    
    NSArray *titles = @[@"确定", @"取消"];
    CGFloat leftGap = 0;
    CGFloat width = (SEL_DIALOG_W - 2)/2;
    for (int i = 0; i < titles.count; i ++) {
        UIButton *button = [UIButton customButton];
        button.frame = rectMake(leftGap, 1, width, 45);
        [button setTitle:titles[i]];
        [button setTitleFont:systemFont(14)];
        [button setTitleColor:sysBlackColor()];
        [button setHTitleColor:rgbColor(240, 102, 44)];
        button.tag = i + 1;
        [button addTarget:self action:@selector(buttonAction:)];
        [buttonView addSubview:button];
        
        leftGap += width + 1;
    }
    
    // Line
    UIImageView *topLine = [[UIImageView alloc]init];
    topLine.backgroundColor = sysLightGrayColor();
    topLine.frame = rectMake(0, 0, SEL_DIALOG_W, 0.3);
    [buttonView addSubview:topLine];
    
    UIImageView *midLine = [[UIImageView alloc]init];
    midLine.frame = rectMake(SEL_DIALOG_W/2 - 0.3, 1, 0.3, 45);
    midLine.backgroundColor = sysLightGrayColor();
    [buttonView addSubview:midLine];
    
    return _buttonView;
}

#pragma mark - Method

- (void)showInView:(UIView *)view
{
    if ([view isKindOfClass:[UIView class]]) {
        [view addSubview:self.mainBGView];
        
        CGRect frame = rectMake(0, 0, view.frame.size.width, view.frame.size.height);
        self.frame = frame;
        self.mainBGView.frame = frame;
        self.titleLabel.text = _title;
        
        // Resize with dataList
        CGFloat delta = 0;
        if (self.dataList) {
            NSInteger count = self.dataList.count;
            if (count > 3) {
                delta = 40.0 * (count - 3);
            }
            delta = (delta > view.frame.size.height - 40 - SEL_DIALOG_H)?view.frame.size.height - 20:delta;
        }
        
        CGFloat height = SEL_DIALOG_H + delta;
        height = (height > screenHeight())?screenHeight() - tabHeight() * 2 - statusHeight():height;
        
        self.mainView.frame = rectMake((frame.size.width - SEL_DIALOG_W)/2, frame.size.height, SEL_DIALOG_W, height);
        self.mainTable.frame = rectMake(0, 40, SEL_DIALOG_W, height - 85.7);
        self.buttonView.frame = rectMake(0, height - 46, SEL_DIALOG_W, 46);
        self.mainBGView.backgroundColor = rgbaColor(0, 0, 0, 0);
        
        // Refresh list
        [self.mainTable runOnMainThread:@selector(reloadData)];
        
        CGFloat topGap = (screenHeight() - statusHeight() - height)/2;
        __weak CSelectionDialog *weakself = self;
        [UIView animateWithDuration:0.25 animations:^{
            weakself.mainBGView.backgroundColor = rgbaColor(0, 0, 0, 0.6);
            weakself.mainView.frame = rectMake((frame.size.width - SEL_DIALOG_W)/2, topGap, SEL_DIALOG_W, height);
        }];
    }
}

- (void)hide
{
    __weak CSelectionDialog *weakself = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakself.mainBGView.backgroundColor = rgbaColor(0, 0, 0, 0);
        weakself.mainView.frame = rectMake((self.frame.size.width - SEL_DIALOG_W)/2, self.frame.size.height, SEL_DIALOG_W, SEL_DIALOG_H);
    } completion:^(BOOL finished) {
        if (finished) {
            [weakself.mainBGView removeFromSuperview];
            weakself.dataList = nil;
        }
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectionDialogCallback:)]) {
        [_delegate selectionDialogCallback:self];
    }
}

- (BOOL)isPoint:(CGPoint)point inRect:(CGRect)rect
{
    CGFloat xmin = rect.origin.x;
    CGFloat ymin = rect.origin.y;
    CGFloat xmax = rect.origin.x + rect.size.width;
    CGFloat ymax = rect.origin.y + rect.size.height;
    
    return (point.x >= xmin) && (point.x <= xmax) && (point.y >= ymin) && (point.y <= ymax);
}

#pragma mark - Action

- (void)tapAction:(UIGestureRecognizer *)recognizer
{
    [self hide];
}

- (void)buttonAction:(UIButton *)button
{
    [self hide];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataList && [self.dataList isKindOfClass:[NSArray class]]) {
        return self.dataList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSelectionDialogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSelectionDialogCell"];
    if (!cell) {
        registerCellNib(tableView, @"CSelectionDialogCell", @"CSelectionDialogCell");
        cell = [tableView dequeueReusableCellWithIdentifier:@"CSelectionDialogCell"];
    }
    cell.isItemSelected = NO;
    [cell setCellData:self.dataList[indexPath.row]];
    
    for (NSString *item in self.indexArray) {
        NSInteger index = [item integerValue];
        if (indexPath.row == index) {
            cell.isItemSelected = YES;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 刷新列表
    [tableView reloadData];
    
    // Selected or cancel
    BOOL selected = YES;
    for (NSString *item in self.indexArray) {
        NSInteger selectedIndex = [item integerValue];
        if (selectedIndex == indexPath.row) {
            selected = NO;
        }
    }
    
    NSString *index = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:indexPath.row]];
    if (!self.multiple) {
        self.indexArray = selected?[NSArray arrayWithObject:index]:nil;
    } else {
        if (!self.indexArray) {
            self.indexArray = selected?[NSArray arrayWithObject:index]:nil;
            return;
        }
        
        NSMutableArray *temArray = [NSMutableArray arrayWithArray:self.indexArray];
        if (selected) {
            [temArray addObject:index];
        } else {
            [temArray removeObject:index];
        }
        
        self.indexArray = temArray;
        temArray = nil;
    }
    
    [tableView reloadData];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.mainView];
    if ([self isPoint:point inRect:self.mainView.bounds]) {
        return NO;
    }
    
    return YES;
}

@end
