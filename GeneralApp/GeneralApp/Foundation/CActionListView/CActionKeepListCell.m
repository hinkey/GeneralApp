//
//  CActionKeepListCell.m
//  UniversalApp
//
//  Created by Cailiang on 15/7/17.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import "CActionKeepListCell.h"
#import "NSDate+UAExtension.h"

@interface CActionKeepListCell ()

@property (assign, nonatomic) IBOutlet UILabel *labelMonth;
@property (assign, nonatomic) IBOutlet UILabel *labelDate;
@property (assign, nonatomic) IBOutlet UILabel *labelContent;
@property (assign, nonatomic) IBOutlet UIImageView *topLine;
@property (assign, nonatomic) IBOutlet UIImageView *bottomLine;

@end

@implementation CActionKeepListCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.bottomLineHidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(id)cellData
{
    if (checkClass(cellData, NSDictionary)) {
        self.labelMonth.text = [NSString stringWithFormat:@"%@个月", cellData[@"MCycle"]];
        self.labelContent.text = cellData[@"Name"];
        
        NSString *month = [NSString stringWithFormat:@"%@", cellData[@"Datetime"]];
        if (checkClass(month, NSString)) {
            if (month.length >= 10) {
                month = [month substringToIndex:10];
            } else {
                month = [[NSDate date]stringWithFormat:@"yyyy-MM-dd"];
            }
            
            self.labelDate.text = month;
        }
    }
}

- (void)setBottomLineHidden:(BOOL)hidden
{
    _bottomLineHidden = hidden;
    
    self.bottomLine.hidden = hidden;
}

@end
