//
//  ProductCommentCell.m
//  LXPig
//
//  Created by leexiang on 15/4/23.
//
//

#import "ProductCommentCell.h"

@implementation ProductCommentCell

- (void)awakeFromNib {
    // Initialization code
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 25;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
