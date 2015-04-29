//
//  CartTableViewCellHead.m
//  LXPig
//
//  Created by leexiang on 15/4/27.
//
//

#import "CartTableViewCellHead.h"

@interface CartTableViewCellHead ()

@end

@implementation CartTableViewCellHead

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)buttonClick:(id)sender
{
    self.checkBtn.selected = !self.checkBtn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cartTableViewCellHead:isCheck:)]) {
        [self.delegate cartTableViewCellHead:self isCheck:self.checkBtn.selected];
    }
}

@end
