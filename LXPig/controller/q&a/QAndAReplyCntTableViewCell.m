//
//  QAndAReplyCntTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/9.
//
//

#import "QAndAReplyCntTableViewCell.h"

@implementation QAndAReplyCntTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCell:(NSDictionary *)dic{
    self.cntLabel.text = [NSString stringWithFormat:@"共%@条回复",dic[@"replyCnt"]];
}
@end
