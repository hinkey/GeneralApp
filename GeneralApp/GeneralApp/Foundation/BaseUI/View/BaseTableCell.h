//
//  BaseTableViewCell.h
//  UniversalApp
//
//  Created by Cailiang on 14/12/30.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "UIView+UAExtension.h"
#import "NSString+UAExtension.h"

@interface BaseTableCell : UITableViewCell

@property (nonatomic, assign) id cellData;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;

// For push
@property (nonatomic, assign) UINavigationController *navigationController;

@end
