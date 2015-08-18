//
//  CPopMenuCell.m
//  UniversalApp
//
//  Created by Cailiang on 15/7/17.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import "CPopMenuCell.h"

@interface CPopMenuCell ()

@property (assign, nonatomic) IBOutlet UILabel *labelTitle;

@end

@implementation CPopMenuCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCellData:(id)cellData
{
    if (checkClass(cellData, NSString)) {
        self.labelTitle.text = cellData;
    }
}

@end
