//
//  PSYButtonTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/16.
//
//

#import "PSYButtonTableViewCell.h"

@implementation PSYButtonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(psyButtonClickCell:)]) {
        [self.delegate psyButtonClickCell:self];
    }
}

@end
