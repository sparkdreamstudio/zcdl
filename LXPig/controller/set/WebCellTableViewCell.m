//
//  WebCellTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/31.
//
//

#import "WebCellTableViewCell.h"

@implementation WebCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.webView.scrollView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
