#import "CSelectionDialogCell.h"

@interface CSelectionDialogCell ()

@property (assign, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) IBOutlet UIImageView *selectedView;

@end

@implementation CSelectionDialogCell

- (void)awakeFromNib
{
    // Initialization code
    self.isItemSelected = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCellData:(id)data
{
    if (data && [data isKindOfClass:[NSString class]]) {
        self.titleLabel.text = data;
    }
}

- (void)setIsItemSelected:(BOOL)selected
{
    if (selected) {
        self.selectedView.image = loadImage(@"sel_seleted");
    } else {
        self.selectedView.image = loadImage(@"sel_normal");
    }
}

@end
