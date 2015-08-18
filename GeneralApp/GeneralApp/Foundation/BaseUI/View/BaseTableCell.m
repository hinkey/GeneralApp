//
//  BaseTableViewCell.m
//  UniversalApp
//
//  Created by Cailiang on 14/12/30.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import "BaseTableCell.h"

@implementation BaseTableCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Properties

- (UINavigationController *)navigationController
{
    if (_navigationController) {
        return _navigationController;
    }
    
    _navigationController = self.viewController.navigationController;
    return _navigationController;
}

@end
