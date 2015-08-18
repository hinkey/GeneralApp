//
//  CPopMenuView.h
//  UniversalApp
//
//  Created by Cailiang on 15/7/17.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CPopMenuViewDelagete <NSObject>

@required
- (void)popMenuViewDidSelect:(NSInteger)index;

@end

@interface CPopMenuView : NSObject

@property (nonatomic, assign) id<CPopMenuViewDelagete> delegate;
@property (nonatomic, readonly) BOOL isHidden;
@property (nonatomic, copy) NSArray *dataList;

- (void)showInView:(UIView *)view origin:(CGPoint)point;
- (void)hide;

@end
