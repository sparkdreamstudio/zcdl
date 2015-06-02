//
//  MyQuestionDetailTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/10.
//
//

#import "MyQuestionDetailTableViewCell.h"

@interface MyQuestionDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *answerUser;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UILabel *acceptLabel;

@end

@implementation MyQuestionDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.acceptLabel.layer.masksToBounds = YES;
    self.acceptLabel.layer.borderColor = [UIColor colorWithRed:0x01/255.f green:0xcc/255.f blue:0x1a/255.f alpha:1].CGColor;
    self.acceptLabel.layer.borderWidth = 1;
    self.acceptLabel.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)acceptBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionDetailCell:AcceptBtnClick:)]) {
        [self.delegate questionDetailCell:self AcceptBtnClick:sender];
    }
}

-(void)loadCell:(NSDictionary*)dic AndIsSolve:(NSInteger)solve
{
    if (solve == 0) {
        self.acceptBtn.hidden = NO;
        self.acceptLabel.hidden = YES;
    }
    else
    {
        self.acceptBtn.hidden = YES;
        if([dic[@"isAccept"] integerValue] == 1)
        {
            self.acceptLabel.hidden = NO;
        }
        else{
            self.acceptLabel.hidden = YES;
        }
    }
    
    if(dic[@"members"][@"nickName"] && [dic[@"members"][@"nickName"] length]>0)
    {
        self.answerUser.text = [NSString stringWithFormat:@"%@回复",dic[@"members"][@"nickName"]];
    }
    else
    {
        NSMutableString* userName = [NSMutableString stringWithString:self.answerUser.text = dic[@"members"][@"userName"]];
        [userName replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.answerUser.text = [NSString stringWithFormat:@"%@回复",userName];
    }
    
    self.content.text = dic[@"content"];

    self.time.text = [dic[@"replyTime"] substringWithRange:NSMakeRange(0, [dic[@"replyTime"] length]-3)];
}
@end
