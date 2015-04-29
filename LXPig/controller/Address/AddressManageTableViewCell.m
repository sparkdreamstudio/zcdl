//
//  AddressManageTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/4/30.
//
//

#import "AddressManageTableViewCell.h"

@implementation AddressManageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedImageView.hidden = !selected;
    if (selected) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [self setBackgroundColor:[UIColor colorWithRed:0xf3/255.f green:0xf3/255.f blue:0xf3/255.f alpha:1]];
    }
    
    // Configure the view for the selected state
}

@end
