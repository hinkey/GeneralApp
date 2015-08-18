//
//  CActionListCell.h
//  UniversalApp
//
//  Created by Cailiang on 15/7/15.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import "BaseTableCell.h"

typedef NS_ENUM(NSInteger, CActionType)
{
    CActionTypeMaintain = 0,
    CActionTypeWork     = 1,
    CActionTypeKeep     = 2,
};

@interface CActionListCell : BaseTableCell

// Set type before set cellData
@property (nonatomic, assign) CActionType type;

@end
