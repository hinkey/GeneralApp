//
//  CActionListView.h
//  UniversalApp
//
//  Created by Cailiang on 15/7/14.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CActionListCell.h"

@protocol CActionListViewDelegate <NSObject>

@required
- (void)actionListDidSelected:(NSInteger)index;
- (void)actionListDidHidden;

@end

@interface CActionListView : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) id<CActionListViewDelegate> delegate;
@property (nonatomic, assign) CActionType type;
@property (nonatomic, retain) NSArray *dataList;

- (void)showInView:(UIView *)view;

@end
