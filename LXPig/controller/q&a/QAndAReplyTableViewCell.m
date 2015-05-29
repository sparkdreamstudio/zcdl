//
//  QAndAReplyTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/9.
//
//

#import "QAndAReplyTableViewCell.h"

@implementation QAndAReplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.isAcceptLabel.layer.masksToBounds = YES;
    self.isAcceptLabel.layer.borderColor = [UIColor colorWithRed:0x01/255.f green:0xcc/255.f blue:0x1a/255.f alpha:1].CGColor;
    self.isAcceptLabel.layer.borderWidth = 1;
    self.isAcceptLabel.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadCell:(NSDictionary *)dic
{
    self.replyUserLabel.text = [NSString stringWithFormat:@"%@回答",[dic[@"members"] objectForKey:@"name"]];
    self.replyTime.text = dic[@"replyTime"];
    self.replyTime.font = [UIFont systemFontOfSize:13];
    self.content.text = dic[@"content"];
    self.isAcceptLabel.hidden = [dic[@"isAccept"] integerValue]==0;
}
@end
