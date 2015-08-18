//
//  CActionListView.m
//  UniversalApp
//
//  Created by Cailiang on 15/7/14.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import "CActionListView.h"
#import "Constants.h"
#import "UIButton+UAExtension.h"
#import "NSObject+UAExtension.h"
#import "CActionKeepListCell.h"

@interface CActionListView () <UITableViewDataSource, UITableViewDelegate>
{
    UITapGestureRecognizer *_tap;
}

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation CActionListView

#pragma mark - Properties

- (UIView *)backgroundView
{
    if (_backgroundView) {
        return _backgroundView;
    }
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.frame = rectMake(0, 0, screenWidth(), screenHeight() - statusHeight());
    backgroundView.backgroundColor = rgbaColor(0, 0, 0, 0.6);
    backgroundView.alpha = 0;
    backgroundView.userInteractionEnabled = YES;
    _backgroundView = backgroundView;
    
    // Tap
    _tap = [[UITapGestureRecognizer alloc]init];
    _tap.numberOfTapsRequired = 1;
    _tap.numberOfTouchesRequired = 1;
    [_tap addTarget:self action:@selector(tapAction)];
    [backgroundView addGestureRecognizer:_tap];
    
    return _backgroundView;
}

- (UIView *)contentView
{
    if (_contentView) {
        return _contentView;
    }
    
    CGFloat height = screenHeight() - statusHeight() - naviHeight() - 130;
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = rectMake(0, screenHeight() - statusHeight(), screenWidth(), height);
    contentView.backgroundColor = sysWhiteColor();
    contentView.userInteractionEnabled = YES;
    _contentView = contentView;
    
    // Cancel
    UIButton *button = [UIButton customButton];
    button.frame = rectMake(20, height - 50, screenWidth() - 40, 40);
    [button setTitle:@"取消"];
    [button setTitleFont:systemFont(16)];
    [button setTitleColor:sysGrayColor()];
    [button setHTitleColor:sysLightGrayColor()];
    
    button.layer.cornerRadius = 6;
    button.layer.borderWidth = 0.3;
    button.layer.borderColor = sysGrayColor().CGColor;
    [button addTarget:self action:@selector(tapAction)];
    [contentView addSubview:button];
    
    // List
    self.tableView.frame = rectMake(0, 35, screenWidth(), height - 90);
    [contentView addSubview:self.tableView];
    
    return _contentView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = rectMake(10, 0, screenWidth() - 20, 30);
    titleLabel.backgroundColor = sysClearColor();
    titleLabel.font = systemFont(16);
    titleLabel.textColor = sysGrayColor();
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    return _titleLabel;
}

- (UITableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    _tableView = tableView;
    
    return _tableView;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = _title;
}

- (void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    
    if (_tableView) {
        [_tableView runOnMainThread:@selector(reloadData)];
    }
}

#pragma mark - Action

- (void)tapAction
{
    [self hide];
}

#pragma mark - Methods

- (void)showInView:(UIView *)view
{
    if (checkClass(view, UIView)) {
        [view addSubview:self.backgroundView];
        [view addSubview:self.contentView];
        
        CGRect frame = self.contentView.frame;
        frame.origin.y = screenHeight() - statusHeight() - frame.size.height;
        
        __weak CActionListView *weakself = self;
        [UIView animateWithDuration:0.25 animations:^{
            weakself.backgroundView.alpha = 1.0;
            weakself.contentView.frame = frame;
        }];
    }
}

- (void)hide
{
    CGRect frame = self.contentView.frame;
    frame.origin.y = screenHeight() - statusHeight();
    
    __weak CActionListView *weakself = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakself.backgroundView.alpha = 0;
        weakself.contentView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [weakself.backgroundView removeFromSuperview];
            [weakself.contentView removeFromSuperview];
        }
    }];
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
    if (self.type == CActionTypeKeep) {
        return 50;
    }
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type != CActionTypeKeep) {
        CActionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CActionListCell"];
        if (!cell) {
            registerCellNib(tableView, @"CActionListCell", @"CActionListCell");
            cell = [tableView dequeueReusableCellWithIdentifier:@"CActionListCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.type = self.type;
        
        // Set cell data
        [cell setCellData:_dataList[indexPath.row]];
        
        return cell;
    } else {
        CActionKeepListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CActionKeepListCell"];
        if (!cell) {
            registerCellNib(tableView, @"CActionKeepListCell", @"CActionKeepListCell");
            cell = [tableView dequeueReusableCellWithIdentifier:@"CActionKeepListCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bottomLineHidden = (_dataList.count == (indexPath.row + 1))?NO:YES;
        
        // Set cell data
        [cell setCellData:_dataList[indexPath.row]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
