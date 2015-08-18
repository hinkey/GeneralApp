//
//  CActionListCell.m
//  UniversalApp
//
//  Created by Cailiang on 15/7/15.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import "CActionListCell.h"

@interface CActionListCell ()

@property (assign, nonatomic) IBOutlet UILabel *labelTitle;
@property (assign, nonatomic) IBOutlet UILabel *labelDescription;

@end

@implementation CActionListCell

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
    if (checkClass(cellData, NSDictionary)) {
        switch (_type) {
            case CActionTypeMaintain:
            {
                self.labelTitle.text = [NSString stringWithFormat:@"%@\t%@", cellData[@"Content"], cellData[@"Datetime"]];
                self.labelDescription.text = cellData[@"RepairPerson"];
            }
                break;
                
            case CActionTypeWork:
            {
                self.labelTitle.text = [NSString stringWithFormat:@"%@\t%@", cellData[@"Id"], cellData[@"EventTime"]];
                self.labelDescription.text = cellData[@"Description"];
            }
                break;
                
            default:
            {
                // CActionTypeKeep
                self.labelTitle.text = cellData[@"Name"];
                self.labelDescription.text = @"";
            }
                break;
        }
    }
}

@end
